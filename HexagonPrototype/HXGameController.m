//
//  GameController.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright (c) 2013 kilovolt. All rights reserved.
//

#import "HXGameController.h"

@implementation HXGameController

- (id)init {
	if (self = [super init]) {
		self.gameScene = [[HXGameScene alloc] initWithDelegate:self];
		_game = [[HXGame alloc] initWithGameScene:self.gameScene];
	}
	return self;
}

- (void)activateHexagon:(HXHexagon *)hexagon {
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

#pragma mark -
#pragma mark Battle Methods

- (void)performBattleBetweenAttacker:(HXHexagon *)attacker andDefender:(HXHexagon *)defender {
	NSLog(@"*** New battle between Attacker[%.f,%.f] and Defender[%.f,%.f]",
		  attacker.mapCoordinates.y,
		  attacker.mapCoordinates.x,
		  defender.mapCoordinates.y,
		  defender.mapCoordinates.x);
	[self performRiskyRiskBattleBetweenAttacker:attacker andDefender:defender];
}

- (void)performRiskyRiskBattleBetweenAttacker:(HXHexagon *)attacker andDefender:(HXHexagon *)defender {
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
	
	[_game.map updateTallies];
	self.gameScene.HUDLayer.blueCountLabel.string = [NSString stringWithFormat:@"B: %d", [[_game.map.tallies valueForKey:@"kBlue"] intValue]];
	self.gameScene.HUDLayer.greenCountLabel.string = [NSString stringWithFormat:@"G: %d", [[_game.map.tallies valueForKey:@"kGreen"] intValue]];
}

#pragma mark -
#pragma mark HXGameSceneDelegate Protocol Methods

- (void)switchColor {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	CGPoint touchLocation = [touch locationInView:[[CCDirector sharedDirector] view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	touchLocation = [self.gameScene convertToGameSpace:touchLocation];
	
	_hexagonTouchBegan = [_game.map hexagonContainingPoint:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!_hexagonTouchBegan) {
		[self deactivateHexagon];
		return;
	}
	
	UITouch *touch = [touches anyObject];
	
	CGPoint touchLocation = [touch locationInView:[[CCDirector sharedDirector] view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	touchLocation = [self.gameScene convertToGameSpace:touchLocation];
	
	_hexagonTouchEnded = [_game.map hexagonContainingPoint:touchLocation];
	
	if (!_hexagonTouchEnded) {
		[self deactivateHexagon];
		return;
	}
	
	if (_hexagonTouchBegan == _hexagonTouchEnded) {
		if (!_activatedHexagon) {
			[self activateHexagon:_hexagonTouchBegan];
		} else {
			/*
			 if ([[self.map neighborsOfHexagon:_activatedHexagon] containsObject:_hexagonTouchEnded]) {
			 [self performBattleBetweenAttacker:_activatedHexagon andDefender:_hexagonTouchEnded];
			 }
			 */
			[self deactivateHexagon];
		}
	} else if ([[_game.map neighborsOfHexagon:_hexagonTouchBegan] containsObject:_hexagonTouchEnded]) {
		[self performBattleBetweenAttacker:_hexagonTouchBegan andDefender:_hexagonTouchEnded];
		[self deactivateHexagon];
	}
	
	_hexagonTouchBegan = nil;
	_hexagonTouchEnded = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

@end
