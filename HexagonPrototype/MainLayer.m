//
//  MainLayer.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "MainLayer.h"

@implementation MainLayer

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	MainLayer *layer = [MainLayer node];
	[scene addChild: layer];
	return scene;
}

- (id)init {
	if (self = [super init]) {
		_hexLayer = [[HexagonMapLayer alloc] init];
		[self addChild:_hexLayer];
		
		// Create menu
		_colorButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"color-button.png"]
											   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"color-button-selected.png"]
											   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"color-button.png"]
													   target:_hexLayer
													 selector:@selector(changeColor)];
		_colorButton.position = ccp(450, 280);
		_colorButton.scale = 0.5;
		
		_incrementButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"increment-button.png"]
													selectedSprite:[CCSprite spriteWithSpriteFrameName:@"increment-button-selected.png"]
													disabledSprite:[CCSprite spriteWithSpriteFrameName:@"increment-button.png"]
															target:_hexLayer
														  selector:@selector(increment)];
		_incrementButton.position = ccp(450, 160);
		_incrementButton.scale = 0.5;
		
		_decrementButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"decrement-button.png"]
												   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"decrement-button-selected.png"]
												   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"decrement-button.png"]
														   target:_hexLayer
														 selector:@selector(decrement)];
		_decrementButton.position = ccp(450, 40);
		_decrementButton.scale = 0.5;
		
		_menu = [CCMenu menuWithItems:_colorButton, _incrementButton, _decrementButton, nil];
		_menu.position = ccp(0, 0);
		[self addChild:_menu];
		
		// Create count labels
		_blueCountLabel = [CCLabelTTF labelWithString:@"B: 36" fontName:@"Helvetica" fontSize:20];
		_greenCountLabel = [CCLabelTTF labelWithString:@"G: 36" fontName:@"Helvetica" fontSize:20];
		_blueCountLabel.position = ccp(450, 100);
		_greenCountLabel.position = ccp(450, 210);
		
		[self addChild:_blueCountLabel];
		[self addChild:_greenCountLabel];
		
		[self scheduleUpdate];
	}
	return self;
}

- (void)update:(ccTime)dt {
	_blueCountLabel.string = [NSString stringWithFormat:@"B: %d", [[_hexLayer.tallies valueForKey:@"kBlue"] intValue]];
	_greenCountLabel.string = [NSString stringWithFormat:@"G: %d", [[_hexLayer.tallies valueForKey:@"kGreen"] intValue]];
}

@end
