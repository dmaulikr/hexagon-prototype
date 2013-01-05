//
//  HexagonMap.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HexagonMap.h"

@implementation HexagonMap

- (id)initUsingBatchNode:(CCSpriteBatchNode *)batch withRows:(int)rows andColumns:(int)columns {
	if (self = [super init]) {
		_rows = rows;
		_columns = columns;
		_map = [[NSMutableArray alloc] initWithCapacity:self.rows];
		
		CCSprite *sprite;
		NSMutableArray *column;
		Hexagon *hexagon;
		float radius, width, halfWidth, rowHeight;
		for (int i = 0; i < self.rows; i++) {
			column = [[NSMutableArray alloc] initWithCapacity:self.columns];
			[_map insertObject:column atIndex:i];
			
			for (int j = 0; j < self.columns; j++) {
				sprite = [CCSprite spriteWithSpriteFrameName:@"blue.png"];
				radius = sprite.contentSize.height / 2;
				width = sprite.contentSize.width;
				halfWidth = width / 2;
				rowHeight = 1.5 * radius;
				
				if (i % 2 == 0) {
					sprite.position = ccp(width*j + radius, rowHeight*i + radius);
				} else {
					sprite.position = ccp(width*j + width/2 + radius, rowHeight*i + radius);
				}
				
				hexagon = [[Hexagon alloc] initWithSprite:sprite];
				[column insertObject:hexagon atIndex:j];
				[batch addChild:sprite];
			}
		}
	}
	return self;
}

@end
