//
//  HexagonMapLayer.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HXMapLayer.h"

@implementation HXMapLayer

- (id)initWithDelegate:(id)delegate {
	if (self = [super init]) {
		_delegate = delegate;
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
		self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"HexagonSprites.pvr.ccz"];
		[self addChild:self.batchNode];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HexagonSprites.plist"];
		
		// Manual positioning - this should eventually be automatic
		self.scale = 0.28;
		self.position = ccp(-155, -100);
	}
	return self;
}

#pragma mark -
#pragma mark Cocos2D Touch Methods Overrides

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate touchesBegan:touches withEvent:event];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate touchesMoved:touches withEvent:event];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate touchesEnded:touches withEvent:event];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate touchesCancelled:touches withEvent:event];
}

#pragma mark -
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

#pragma mark -
#pragma mark UIGestureRecognizerDelegate Protocol Methods

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
