//
//  GameScene.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HXGameScene.h"

@implementation HXGameScene

- (id)initWithDelegate:(id)delegate {
	if (self = [super init]) {
		self.mapLayer = [[HXMapLayer alloc] initWithDelegate:delegate];
		self.HUDLayer = [[HXHUDLayer alloc] initWithDelegate:delegate];
		
		[self addChild:self.mapLayer];
		[self addChild:self.HUDLayer];
	}
	return self;
}

- (CGPoint)convertToGameSpace:(CGPoint)worldPoint {
	return [self.mapLayer convertToNodeSpace:worldPoint];
}

@end
