//
//  Hexagon.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "Hexagon.h"

@implementation Hexagon

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName {
	if (self = [super init]) {
		self.sprite = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
		_spriteFrameName = spriteFrameName;
		_spriteFrameNameSelected = [spriteFrameName stringByReplacingOccurrencesOfString:@".png" withString:@"-selected.png"];
		
		_valueLabel = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:50];
	}
	return self;
}

- (BOOL)isInBounds:(CGPoint)point {
	CGPoint location = self.sprite.position;
	float distance = ccpDistance(point, location);
	
	// Fast circular detection
	if (distance < self.sprite.contentSize.height / 2) {
		return YES;
	}
	return NO;
}

#pragma mark Property Overrides

- (void)setSelected:(BOOL)selected {
	if (selected) {
		[self.sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_spriteFrameNameSelected]];
	} else {
		[self.sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_spriteFrameName]];
	}
	_selected = selected;
}

- (void)setValue:(float)value {
	_value = value;
	_valueLabel.string = [NSString stringWithFormat:@"%.f", value];
}

- (void)setColor:(Color)color {
	_color = color;
	switch (color) {
		case kBlue: _spriteFrameName = @"blue.png"; break;
		case kGreen: _spriteFrameName = @"green.png"; break;
		case kOrange: _spriteFrameName = @"orange.png"; break;
		case kPurple: _spriteFrameName = @"purple.png"; break;
		case kRed: _spriteFrameName = @"red.png"; break;
		case kYellow: _spriteFrameName = @"yellow.png"; break;
		default: break;
	}
	_spriteFrameNameSelected = [_spriteFrameName stringByReplacingOccurrencesOfString:@".png" withString:@"-selected.png"];
	if (_selected) {
		[self.sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_spriteFrameNameSelected]];
	} else {
		[self.sprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_spriteFrameName]];
	}
}

#pragma mark Dimensional Methods

- (float)radius {
	return self.sprite.contentSize.height / 2;
}

- (float)width {
	return self.sprite.contentSize.width;
}

- (float)halfWidth {
	return [self width] / 2;
}

- (float)rowHeight {
	return 1.5 * [self radius];
}

@end
