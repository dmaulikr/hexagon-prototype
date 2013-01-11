//
//  HexagonMap.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HXHexagon.h"
#import "HXHUDLayer.h"

@interface HXMap : NSObject <NSFastEnumeration>

@property (nonatomic, strong) NSMutableArray *map;
@property (nonatomic, readonly) int rows;
@property (nonatomic, readonly) int columns;
@property (nonatomic, strong) NSMutableDictionary *tallies;

- (id)initWithRows:(int)rows andColumns:(int)columns;
- (void)generateRandomMap;
- (int)numberOfHexagonsWithColor:(HXColor)color;
- (void)updateTallies;

#pragma mark -
#pragma mark Finding Hexagons

- (HXHexagon *)hexagonContainingPoint:(CGPoint)point;
- (HXHexagon *)hexagonAtMapCoordinates:(CGPoint)coordinates;
- (HXHexagon *)neighborOfHexagon:(HXHexagon *)hexagon inDirection:(HXDirection)direction;
- (NSSet *)neighborsOfHexagon:(HXHexagon *)hexagon;

@end
