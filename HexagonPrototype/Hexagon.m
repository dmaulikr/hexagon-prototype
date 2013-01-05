//
//  Hexagon.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "Hexagon.h"

@implementation Hexagon

- (id)initWithSprite:(CCSprite *)sprite {
	if (self = [super init]) {
		self.sprite = sprite;
	}
	return self;
}

@end
