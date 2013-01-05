//
//  MainLayer.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "MainLayer.h"

@implementation MainLayer

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	MainLayer *layer = [MainLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init {
	if (self = [super init]) {
		_hexLayer = [[HexagonMapLayer alloc] init];
		[self addChild:_hexLayer];
	}
	return self;
}

@end
