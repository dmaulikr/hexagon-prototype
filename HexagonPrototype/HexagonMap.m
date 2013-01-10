//
//  HexagonMap.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HexagonMap.h"

const Color kNeutralColor = kOrange;
const Color kPlayer1Color = kBlue;
const Color kPlayer2Color = kGreen;

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
				hexagon.color = kOrange;
				hexagon.mapCoordinates = ccp(i, j);
				
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
		
		[self generateRandomMap];
	}
	
	return self;
}

- (void)generateRandomMap {
	int randomX, randomY, i = 0;
	Hexagon *hexagon;
	
	for (NSMutableArray *row in _map) {
		for (Hexagon *hex in row) {
			hex.value = (arc4random() % 4) + 1;
			hex.color = kNeutralColor;
		}
	}
	
	while (i < 36) {
		randomX = arc4random() % self.rows;
		randomY = arc4random() % self.columns;
		hexagon = [(NSMutableArray *)[_map objectAtIndex:randomX] objectAtIndex:randomY];
		if (hexagon.color == kNeutralColor) {
			hexagon.color = kPlayer1Color;
			hexagon.value = 5;
			i++;
		} else {
			continue;
		}
	}
	
	i = 0;
	while (i < 36) {
		randomX = arc4random() % self.rows;
		randomY = arc4random() % self.columns;
		hexagon = [(NSMutableArray *)[_map objectAtIndex:randomX] objectAtIndex:randomY];
		if (hexagon.color == kNeutralColor) {
			hexagon.color = kPlayer2Color;
			hexagon.value = 5;
			i++;
		} else {
			continue;
		}
	}
}

- (int)numberOfHexagonsWithColor:(Color)color {
	int count = 0;
	for (NSMutableArray *row in _map) {
		for (Hexagon *hexagon in row) {
			if (hexagon.color == color) {
				count++;
			}
		}
	}
	return count;
}

#pragma mark Finding Hexagons

- (Hexagon *)hexagonContainingPoint:(CGPoint)point {
	for (NSMutableArray *row in _map) {
		for (Hexagon *hexagon in row) {
			if ([hexagon isInBounds:point]) {
				return hexagon;
			}
		}
	}
	return nil;
}

- (Hexagon *)hexagonAtMapCoordinates:(CGPoint)coordinates {
	if (coordinates.x < 0 || coordinates.x >= _rows || coordinates.y < 0 || coordinates.y >= _columns) return nil;
	NSMutableArray *row = [_map objectAtIndex:coordinates.x];
	return [row objectAtIndex:coordinates.y];
}

- (Hexagon *)neighborOfHexagon:(Hexagon *)hexagon inDirection:(Direction)direction {
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
	
	return [self hexagonAtMapCoordinates:coordinates];
}

- (NSSet *)neighborsOfHexagon:(Hexagon *)hexagon {
	NSMutableArray *neightbors = [[NSMutableArray alloc] initWithCapacity:6];
	
	Hexagon *neighborNE = [self neighborOfHexagon:hexagon inDirection:kNorthEast];
	Hexagon *neighborSE = [self neighborOfHexagon:hexagon inDirection:kSouthEast];
	Hexagon *neighborSW = [self neighborOfHexagon:hexagon inDirection:kSouthWest];
	Hexagon *neighborNW = [self neighborOfHexagon:hexagon inDirection:kNorthWest];
	Hexagon *neighborE  = [self neighborOfHexagon:hexagon inDirection:kEast];
	Hexagon *neighborW  = [self neighborOfHexagon:hexagon inDirection:kWest];
	
	if (neighborNE != nil) [neightbors addObject:neighborNE];
	if (neighborSE != nil) [neightbors addObject:neighborSE];
	if (neighborSW != nil) [neightbors addObject:neighborSW];
	if (neighborNW != nil) [neightbors addObject:neighborNW];
	if (neighborE != nil) [neightbors addObject:neighborE];
	if (neighborW != nil) [neightbors addObject:neighborW];
	
	return [[NSSet alloc] initWithArray:neightbors];
}

@end
