//
//  HexagonMapLayer.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HexagonMapLayer.h"

@implementation HexagonMapLayer

- (id)init {
	if (self = [super init]) {
		self.touchEnabled = YES;
		
		// Setup gestures recognizers
		UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
		[pinchRecognizer setDelegate:self];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:pinchRecognizer];
		
		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		[panRecognizer setMinimumNumberOfTouches:2];
		[panRecognizer setMaximumNumberOfTouches:2];
		[panRecognizer setDelegate:self];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:panRecognizer];
		
		// Load hexagon textures and create the sprite batch node
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
		CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"HexagonSprites.pvr.ccz"];
		[self addChild:batchNode];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HexagonSprites.plist"];
		
		// Generate a map
		_map = [[HexagonMap alloc] initInLayer:self usingBatchNode:batchNode withRows:12 andColumns:12];
	}
	return self;
}

- (void)activateHexagon:(Hexagon *)hexagon {
	if (_activatedHexagon) {
		_activatedHexagon.selected = NO;
	}
	_activatedHexagon = hexagon;
	_activatedHexagon.selected = YES;
	NSLog(@"Hexagon at [%.f,%.f] was activated", _activatedHexagon.mapCoordinates.x, _activatedHexagon.mapCoordinates.y);
}

- (void)deactivateHexagon {
	if (_activatedHexagon) {
		NSLog(@"Hexagon at [%.f,%.f] was deactivated", _activatedHexagon.mapCoordinates.x, _activatedHexagon.mapCoordinates.y);
		_activatedHexagon.selected = NO;
		_activatedHexagon = nil;
	} else {
		NSLog(@"No active hexagon to deactivate");
	}
}

- (void)changeColor {
	switch (_activatedHexagon.color) {
		case kBlue: _activatedHexagon.color = kGreen; break;
		case kGreen: _activatedHexagon.color = kOrange; break;
		case kOrange: _activatedHexagon.color = kPurple; break;
		case kPurple: _activatedHexagon.color = kRed; break;
		case kRed: _activatedHexagon.color = kYellow; break;
		case kYellow: _activatedHexagon.color = kBlue; break;
		default: break;
	}
}

- (void)increment {
	_activatedHexagon.value += 1;
}

- (void)decrement {
	_activatedHexagon.value -= 1;
}

#pragma mark Battle Methods

- (void)performBattleBetweenAttacker:(Hexagon *)attacker andDefender:(Hexagon *)defender {
	NSLog(@"*** New battle between Attacker[%.f,%.f] and Defender[%.f,%.f]",
		  attacker.mapCoordinates.y,
		  attacker.mapCoordinates.x,
		  defender.mapCoordinates.y,
		  defender.mapCoordinates.x);
	[self performRiskyRiskBattleBetweenAttacker:attacker andDefender:defender];
}

- (void)performRiskyRiskBattleBetweenAttacker:(Hexagon *)attacker andDefender:(Hexagon *)defender {
	NSLog(@"Beginning Risky Risk battle");
	NSMutableArray *attackerDice = [[NSMutableArray alloc] init];
	NSMutableArray *defenderDice = [[NSMutableArray alloc] init];
	int attackerRoll, defenderRoll, attackerValue, defenderValue, attackerSum = 0, defenderSum = 0, attackerDeduction = 0, defenderDeduction = 0, diceBattleCount;
	attackerValue = (int)attacker.value;
	defenderValue = (int)defender.value;
	
	for (int i = 0; i < attackerValue; i++) {
		attackerRoll = (arc4random() % 6) + 1;
		[attackerDice addObject:[[NSNumber alloc] initWithInt:attackerRoll]];
		NSLog(@"Attacker roll #%d is %d", i, attackerRoll);
	}
	for (NSNumber *roll in attackerDice) {
		attackerSum += roll.intValue;
	}
	NSLog(@"Attacker sum is %d", attackerSum);
	
	for (int i = 0; i < defenderValue; i++) {
		defenderRoll = (arc4random() % 6) + 1;
		[defenderDice addObject:[[NSNumber alloc] initWithInt:defenderRoll]];
		NSLog(@"Defender roll #%d is %d", i, defenderRoll);
	}
	for (NSNumber *roll in defenderDice) {
		defenderSum += roll.intValue;
	}
	NSLog(@"Defender sum is %d", defenderSum);
	
	if (defenderDice.count < attackerDice.count) {
		diceBattleCount = defenderDice.count;
	} else {
		diceBattleCount = attackerDice.count;
	}
	
	for (int i = 0; i < diceBattleCount; i++) {
		attackerRoll = ((NSNumber *)[attackerDice objectAtIndex:i]).intValue;
		defenderRoll = ((NSNumber *)[defenderDice objectAtIndex:i]).intValue;
		if (attackerRoll > defenderRoll) {
			defenderDeduction++;
		} else {
			attackerDeduction++;
		}
	}
	attackerValue -= attackerDeduction;
	defenderValue -= defenderDeduction;
	NSLog(@"Attacker loses %d dice and defender loses %d dice", attackerDeduction, defenderDeduction);
	
	if (attackerSum > defenderSum) {
		attacker.value = 1;
		defender.value = (float)attackerValue - 1;
		defender.color = attacker.color;
		NSLog(@"Attacker wins!");
	} else {
		attacker.value = attackerValue;
		defender.value = defenderValue;
		NSLog(@"Defender wins!");
	}
}

#pragma mark Cocos2D Touch Methods Overrides

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	// Convert touch to a point in the layer
	CGPoint touchLocation = [touch locationInView:[[CCDirector sharedDirector] view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	touchLocation = [self convertToNodeSpace:touchLocation];
	
	_hexagonTouchBegan = [_map findHexagonContainingPoint:touchLocation];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!_hexagonTouchBegan) {
		[self deactivateHexagon];
		return;
	}
	
	UITouch *touch = [touches anyObject];
	
	// Convert touch to a point in the layer
	CGPoint touchLocation = [touch locationInView:[[CCDirector sharedDirector] view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	touchLocation = [self convertToNodeSpace:touchLocation];
	
	_hexagonTouchEnded = [_map findHexagonContainingPoint:touchLocation];
	
	if (!_hexagonTouchEnded) {
		[self deactivateHexagon];
		return;
	}
	
	if (_hexagonTouchBegan == _hexagonTouchEnded) {
		if (!_activatedHexagon) {
			[self activateHexagon:_hexagonTouchBegan];
		} else {
			if ([[_map neighborsOfHexagon:_activatedHexagon] containsObject:_hexagonTouchEnded]) {
				[self performBattleBetweenAttacker:_activatedHexagon andDefender:_hexagonTouchEnded];
			}
			[self deactivateHexagon];
		}
	} else if ([[_map neighborsOfHexagon:_hexagonTouchBegan] containsObject:_hexagonTouchEnded]) {
		[self performBattleBetweenAttacker:_hexagonTouchBegan andDefender:_hexagonTouchEnded];
		[self deactivateHexagon];
	}
	
	_hexagonTouchBegan = nil;
	_hexagonTouchEnded = nil;
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

#pragma mark UIGestureRecognizer Handlers

- (void)handlePinch:(UIPinchGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateChanged) {
		self.scale = self.scale * sender.scale;
		
		float xP = self.position.x - self.anchorPoint.x;
		float yP = self.position.y - self.anchorPoint.y;
		float xPP = xP * sender.scale;
		float yPP = yP * sender.scale;
		float xPPP = xPP + self.anchorPoint.x;
		float yPPP = yPP + self.anchorPoint.y;
		
		self.position = ccp(xPPP, yPPP);
		
		sender.scale = 1.0;
	}
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateChanged) {
		CGPoint adjusted = [sender translationInView:sender.view];
		adjusted = ccp(adjusted.x, -adjusted.y);
		self.position = ccpAdd(adjusted, self.position);
		[sender setTranslation:ccp(0, 0) inView:sender.view];
	}
}

#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	return YES;
}

@end
