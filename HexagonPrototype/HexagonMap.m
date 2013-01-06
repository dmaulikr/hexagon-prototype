//
//  HexagonMap.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HexagonMap.h"

@implementation HexagonMap

- (id)initInLayer:(CCLayer *)layer usingBatchNode:(CCSpriteBatchNode *)batch withRows:(int)rows andColumns:(int)columns {
	if (self = [super init]) {
		_rows = rows;
		_columns = columns;
		_map = [[NSMutableArray alloc] initWithCapacity:self.rows];
		
		Hexagon *hexagon;
		NSMutableArray *column;
		
		hexagon = [[Hexagon alloc] initWithSpriteFrameName:@"blue.png"];
		float radius = [hexagon radius];
		float width = [hexagon width];
		float halfWidth = [hexagon halfWidth];
		float rowHeight = [hexagon rowHeight];
		
		for (int i = 0; i < self.rows; i++) {
			column = [[NSMutableArray alloc] initWithCapacity:self.columns];
			[_map insertObject:column atIndex:i];
			
			for (int j = 0; j < self.columns; j++) {
				hexagon = [[Hexagon alloc] initWithSpriteFrameName:@"blue.png"];
				hexagon.mapCoordinates = ccp(i, j);
				hexagon.value = 3;
				
				if (i % 2 == 0) {
					hexagon.sprite.position = ccp(width*j + radius, rowHeight*i + radius);
				} else {
					hexagon.sprite.position = ccp(width*j + halfWidth + radius, rowHeight*i + radius);
				}
				
				hexagon.valueLabel.position = hexagon.sprite.position;
				[layer addChild:hexagon.valueLabel];
				[batch addChild:hexagon.sprite];
				[column insertObject:hexagon atIndex:j];
			}
		}
	}
	return self;
}

- (Hexagon *)findHexagonContainingPoint:(CGPoint)point {
	for (NSMutableArray *row in _map) {
		for (Hexagon *hexagon in row) {
			if ([hexagon isInBounds:point]) {
				return hexagon;
			}
		}
	}
	return nil;
}

- (CGPoint)neighborOfHexagon:(Hexagon *)hexagon inDirection:(Direction)direction {
	CGPoint coordinates = hexagon.mapCoordinates;
	if ((int)coordinates.x % 2 == 0) {
		switch (direction) {
			case kNorthEast: coordinates.x += 1; break;
			case kSouthEast: coordinates.x -= 1; break;
			case kSouthWest: coordinates.x -= 1; coordinates.y -= 1; break;
			case kNorthWest: coordinates.x += 1; coordinates.y -= 1; break;
			case kEast: coordinates.y += 1; break;
			case kWest: coordinates.y -=1; break;
			default: break;
		}
	} else {
		switch (direction) {
			case kNorthEast: coordinates.x += 1; coordinates.y += 1; break;
			case kSouthEast: coordinates.x -= 1; coordinates.y += 1; break;
			case kSouthWest: coordinates.x -= 1; break;
			case kNorthWest: coordinates.x += 1; break;
			case kEast: coordinates.y += 1; break;
			case kWest: coordinates.y -=1; break;
			default: break;
		}
	}
	return coordinates;
}

- (NSSet *)neighborsOfHexagon:(Hexagon *)hexagon {
	NSMutableArray *neightbors = [[NSMutableArray alloc] initWithCapacity:6];
	
	Hexagon *neighborNE = [self hexagonAtMapCoordinates:[self neighborOfHexagon:hexagon inDirection:kNorthEast]];
	Hexagon *neighborSE = [self hexagonAtMapCoordinates:[self neighborOfHexagon:hexagon inDirection:kSouthEast]];
	Hexagon *neighborSW = [self hexagonAtMapCoordinates:[self neighborOfHexagon:hexagon inDirection:kSouthWest]];
	Hexagon *neighborNW = [self hexagonAtMapCoordinates:[self neighborOfHexagon:hexagon inDirection:kNorthWest]];
	Hexagon *neighborE  = [self hexagonAtMapCoordinates:[self neighborOfHexagon:hexagon inDirection:kEast]];
	Hexagon *neighborW  = [self hexagonAtMapCoordinates:[self neighborOfHexagon:hexagon inDirection:kWest]];
	
	if (neighborNE != nil) [neightbors addObject:neighborNE];
	if (neighborSE != nil) [neightbors addObject:neighborSE];
	if (neighborSW != nil) [neightbors addObject:neighborSW];
	if (neighborNW != nil) [neightbors addObject:neighborNW];
	if (neighborE != nil) [neightbors addObject:neighborE];
	if (neighborW != nil) [neightbors addObject:neighborW];
	
	return [[NSSet alloc] initWithArray:neightbors];
}

- (Hexagon *)hexagonAtMapCoordinates:(CGPoint)coordinates {
	if (coordinates.x < 0 || coordinates.x >= _rows || coordinates.y < 0 || coordinates.y >= _columns) return nil;
	NSMutableArray *row = [_map objectAtIndex:coordinates.x];
	return [row objectAtIndex:coordinates.y];
}

@end
