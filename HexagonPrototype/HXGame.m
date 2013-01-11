//
//  Game.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright (c) 2013 kilovolt. All rights reserved.
//

#import "HXGame.h"

@implementation HXGame

- (id)initWithGameScene:(HXGameScene *)gameScene {
	if (self = [super init]) {
		self.gameScene = gameScene;
		self.map = [[HXMap alloc] initWithRows:12 andColumns:12];
		[self initializeGameScene];
	}
	return self;
}

- (void)initializeGameScene {
	for (HXHexagon *hexagon in self.map) {
		[_gameScene.mapLayer.batchNode addChild:hexagon.sprite];
		[_gameScene.mapLayer addChild:hexagon.valueLabel];
	}
}

@end
