//
//  HexagonMap.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HXMap.h"

const HXColor kNeutralColor = kOrange;
const HXColor kPlayer1Color = kBlue;
const HXColor kPlayer2Color = kGreen;

@implementation HXMap

- (id)initWithRows:(int)rows andColumns:(int)columns {
	if (self = [super init]) {
		_rows = rows;
		_columns = columns;
		_map = [[NSMutableArray alloc] initWithCapacity:self.rows];
		
		HXHexagon *hexagon;
		NSMutableArray *column;
		
		hexagon = [[HXHexagon alloc] initWithSpriteFrameName:@"blue.png"];
		float radius = [hexagon radius];
		float width = [hexagon width];
		float halfWidth = [hexagon halfWidth];
		float rowHeight = [hexagon rowHeight];
		
		for (int i = 0; i < self.rows; i++) {
			column = [[NSMutableArray alloc] initWithCapacity:self.columns];
			[_map insertObject:column atIndex:i];
			
			for (int j = 0; j < self.columns; j++) {
				hexagon = [[HXHexagon alloc] initWithSpriteFrameName:@"blue.png"];
				hexagon.color = kOrange;
				hexagon.mapCoordinates = ccp(i, j);
				
				if (i % 2 == 0) {
					hexagon.sprite.position = ccp(width*j + radius, rowHeight*i + radius);
				} else {
					hexagon.sprite.position = ccp(width*j + halfWidth + radius, rowHeight*i + radius);
				}
				
				hexagon.valueLabel.position = hexagon.sprite.position;
				[column insertObject:hexagon atIndex:j];
			}
		}
		
		[self generateRandomMap];
		
		self.tallies = [[NSMutableDictionary alloc] init];
		[self updateTallies];
	}
	
	return self;
}

- (void)generateRandomMap {
	int randomX, randomY, i = 0;
	HXHexagon *hexagon;
	
	for (NSMutableArray *row in _map) {
		for (HXHexagon *hex in row) {
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

- (int)numberOfHexagonsWithColor:(HXColor)color {
	int count = 0;
	for (HXHexagon *hexagon in self) {
		if (hexagon.color == color) {
			count++;
		}
	}
	return count;
}

- (void)updateTallies {
	NSArray *keys = [[NSArray alloc] initWithObjects:@"kBlue", @"kGreen", @"kOrange", @"kPurple", @"kRed", @"kYellow", nil];
	NSArray *values = [[NSArray alloc] initWithObjects:
					   [NSNumber numberWithInt:[self numberOfHexagonsWithColor:kBlue]],
					   [NSNumber numberWithInt:[self numberOfHexagonsWithColor:kGreen]],
					   [NSNumber numberWithInt:[self numberOfHexagonsWithColor:kOrange]],
					   [NSNumber numberWithInt:[self numberOfHexagonsWithColor:kPurple]],
					   [NSNumber numberWithInt:[self numberOfHexagonsWithColor:kRed]],
					   [NSNumber numberWithInt:[self numberOfHexagonsWithColor:kYellow]],
					   nil];
	self.tallies = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
}

#pragma mark -
#pragma mark Finding Hexagons

- (HXHexagon *)hexagonContainingPoint:(CGPoint)point {
	for (HXHexagon *hexagon in self) {
		if ([hexagon isInBounds:point]) {
			return hexagon;
		}
	}
	return nil;
}

- (HXHexagon *)hexagonAtMapCoordinates:(CGPoint)coordinates {
	if (coordinates.x < 0 || coordinates.x >= _rows || coordinates.y < 0 || coordinates.y >= _columns) return nil;
	NSMutableArray *row = [_map objectAtIndex:coordinates.x];
	return [row objectAtIndex:coordinates.y];
}

- (HXHexagon *)neighborOfHexagon:(HXHexagon *)hexagon inDirection:(HXDirection)direction {
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

- (NSSet *)neighborsOfHexagon:(HXHexagon *)hexagon {
	NSMutableArray *neightbors = [[NSMutableArray alloc] initWithCapacity:6];
	
	HXHexagon *neighborNE = [self neighborOfHexagon:hexagon inDirection:kNorthEast];
	HXHexagon *neighborSE = [self neighborOfHexagon:hexagon inDirection:kSouthEast];
	HXHexagon *neighborSW = [self neighborOfHexagon:hexagon inDirection:kSouthWest];
	HXHexagon *neighborNW = [self neighborOfHexagon:hexagon inDirection:kNorthWest];
	HXHexagon *neighborE  = [self neighborOfHexagon:hexagon inDirection:kEast];
	HXHexagon *neighborW  = [self neighborOfHexagon:hexagon inDirection:kWest];
	
	if (neighborNE != nil) [neightbors addObject:neighborNE];
	if (neighborSE != nil) [neightbors addObject:neighborSE];
	if (neighborSW != nil) [neightbors addObject:neighborSW];
	if (neighborNW != nil) [neightbors addObject:neighborNW];
	if (neighborE != nil) [neightbors addObject:neighborE];
	if (neighborW != nil) [neightbors addObject:neighborW];
	
	return [[NSSet alloc] initWithArray:neightbors];
}

#pragma mark -
#pragma mark NSFastEnumeration Protocol Methods

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
	NSUInteger count = 0;
	
	if (state->state == 0) {
		state->mutationsPtr = &state->extra[0];
	}
	
	if (state->state < self.rows * self.columns) {
		state->itemsPtr = buffer;
		int row, column;
		while ((state->state < self.rows * self.columns) && (count < len)) {
			row = state->state / self.rows;
			column = state->state % self.columns;
			buffer[count] = [[_map objectAtIndex:row] objectAtIndex:column];
			state->state++;
			count++;
		}
	} else {
		count = 0;
	}
	
	return count;
}

@end
