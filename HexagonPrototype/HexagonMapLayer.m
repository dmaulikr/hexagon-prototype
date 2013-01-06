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
		// Setup gestures recognizers
		UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
		[pinchRecognizer setDelegate:self];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:pinchRecognizer];
		
		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		[panRecognizer setMinimumNumberOfTouches:2];
		[panRecognizer setMaximumNumberOfTouches:2];
		[panRecognizer setDelegate:self];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:panRecognizer];
		
		UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[tapRecognizer setNumberOfTapsRequired:1];
		[tapRecognizer setNumberOfTouchesRequired:1];
		[tapRecognizer setDelegate:self];
		[[[CCDirector sharedDirector] view] addGestureRecognizer:tapRecognizer];
		
		// Load hexagon textures and create the sprite batch node
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
		CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"HexagonSprites.pvr.ccz"];
		[self addChild:batchNode];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HexagonSprites.plist"];
		
		// Generate a map
		_map = [[HexagonMap alloc] initUsingBatchNode:batchNode withRows:12 andColumns:12];
	}
	return self;
}

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

- (void)handleTap:(UITapGestureRecognizer *)sender {
	CGPoint tapLocation = [sender locationInView:[[CCDirector sharedDirector] view]];
	tapLocation = [[CCDirector sharedDirector] convertToGL:tapLocation];
	tapLocation = [self convertToNodeSpace:tapLocation];
	
	Hexagon *hexagon = [_map findHexagonContainingPoint:tapLocation];
	
	if (hexagon) {
		if (_selectedHexagon) {
			if (hexagon == _selectedHexagon) {
				hexagon.selected = NO;
				_selectedHexagon = nil;
			} else {
				if ([[_map neighborsOfHexagon:_selectedHexagon] containsObject:hexagon]) {
					NSLog(@"Battle!");
				}
				_selectedHexagon.selected = NO;
				_selectedHexagon = nil;
			}
		} else {
			hexagon.selected = YES;
			_selectedHexagon = hexagon;
		}
	} else {
		_selectedHexagon.selected = NO;
		_selectedHexagon = nil;
	}
}

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
