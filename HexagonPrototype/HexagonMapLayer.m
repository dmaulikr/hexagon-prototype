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
		// Setup gestures
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
		_map = [[HexagonMap alloc] initUsingBatchNode:batchNode
											 withRows:12
										   andColumns:12];
	}
	return self;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender {
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

- (void)handlePan:(UIPanGestureRecognizer *)sender {
	CGPoint adjusted = [sender translationInView:sender.view];
	adjusted = ccp(adjusted.x, -adjusted.y);
	self.position = ccpAdd(adjusted, self.position);
	[sender setTranslation:ccp(0, 0) inView:sender.view];
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
