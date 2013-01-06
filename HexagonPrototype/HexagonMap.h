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
- (Hexagon *)findHexagonContainingPoint:(CGPoint)point;
- (CGPoint)neighborOfHexagon:(Hexagon *)hexagon inDirection:(Direction)direction;
- (NSSet *)neighborsOfHexagon:(Hexagon *)hexagon;
- (Hexagon *)hexagonAtMapCoordinates:(CGPoint)coordinates;

@end
