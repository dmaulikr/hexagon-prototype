//
//  Hexagon.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
	kNorthEast,
	kSouthEast,
	kSouthWest,
	kNorthWest,
	kEast,
	kWest
} Direction;

typedef enum {
	kBlue = 0,
	kGreen = 1,
	kOrange = 2,
	kPurple = 3,
	kRed = 4,
	kYellow = 5
} Color;

@interface Hexagon : NSObject {
	NSString *_spriteFrameName;
	NSString *_spriteFrameNameSelected;
}

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGPoint mapCoordinates;
@property (nonatomic, readonly) CCLabelTTF *valueLabel;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) Color color;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName;
- (BOOL)isInBounds:(CGPoint)point;

#pragma mark Dimensional Methods

- (float)radius;
- (float)width;
- (float)halfWidth;
- (float)rowHeight;

@end
