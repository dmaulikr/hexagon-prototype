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
} HXDirection;

typedef enum {
	kBlue = 0,
	kGreen = 1,
	kOrange = 2,
	kPurple = 3,
	kRed = 4,
	kYellow = 5
} HXColor;

@interface HXHexagon : NSObject

@property (nonatomic, strong) NSString *spriteFrameName;
@property (nonatomic, strong) NSString *spriteFrameNameSelected;
@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGPoint mapCoordinates;
@property (nonatomic, readonly) CCLabelTTF *valueLabel;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) HXColor color;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName;
- (BOOL)isInBounds:(CGPoint)point;

#pragma mark -
#pragma mark Dimensional Methods

- (float)radius;
- (float)width;
- (float)halfWidth;
- (float)rowHeight;

@end
