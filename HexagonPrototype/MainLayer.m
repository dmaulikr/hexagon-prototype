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
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position =  ccp(size.width /2 , size.height/2);
		[self addChild: label];
	}
	return self;
}

@end
