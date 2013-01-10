//
//  HexagonMap.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Hexagon.h"

@interface HexagonMap : NSObject {
	NSMutableArray *_map;
}

@property (nonatomic, readonly) int rows;
@property (nonatomic, readonly) int columns;

- (id)initInLayer:(CCLayer *)layer usingBatchNode:(CCSpriteBatchNode *)batch withRows:(int)rows andColumns:(int)columns;
- (void)generateRandomMap;
- (int)numberOfHexagonsWithColor:(Color)color;

#pragma mark Finding Hexagons

- (Hexagon *)hexagonContainingPoint:(CGPoint)point;
- (Hexagon *)hexagonAtMapCoordinates:(CGPoint)coordinates;
- (Hexagon *)neighborOfHexagon:(Hexagon *)hexagon inDirection:(Direction)direction;
- (NSSet *)neighborsOfHexagon:(Hexagon *)hexagon;

@end
