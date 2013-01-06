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

@interface Hexagon : NSObject {
	NSString *_spriteFrameName;
	NSString *_spriteFrameNameSelected;
}

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGPoint mapCoordinates;

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName;
- (BOOL)isInBounds:(CGPoint)point;

#pragma mark Dimensional Methods

- (float)radius;
- (float)width;
- (float)halfWidth;
- (float)rowHeight;

@end
