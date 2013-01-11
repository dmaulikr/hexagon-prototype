//
//  HUDLayer.m
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import "HXHUDLayer.h"

@implementation HXHUDLayer

- (id)initWithDelegate:(id)delegate {
	if (self = [super init]) {
		_delegate = delegate;
		
		_colorButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"color-button.png"]
											   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"color-button-selected.png"]
											   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"color-button.png"]
													   target:_delegate
													 selector:@selector(switchColor)];
		_colorButton.position = ccp(450, 280);
		_colorButton.scale = 0.5;
		
		_incrementButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"increment-button.png"]
												   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"increment-button-selected.png"]
												   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"increment-button.png"]
														   target:_delegate
														 selector:@selector(increment)];
		_incrementButton.position = ccp(450, 160);
		_incrementButton.scale = 0.5;
		
		_decrementButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"decrement-button.png"]
												   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"decrement-button-selected.png"]
												   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"decrement-button.png"]
														   target:_delegate
														 selector:@selector(decrement)];
		_decrementButton.position = ccp(450, 40);
		_decrementButton.scale = 0.5;
		
		_blueCountLabel = [CCLabelTTF labelWithString:@"B: 36" fontName:@"Helvetica" fontSize:20];
		_blueCountLabel.position = ccp(450, 100);
		
		_greenCountLabel = [CCLabelTTF labelWithString:@"G: 36" fontName:@"Helvetica" fontSize:20];
		_greenCountLabel.position = ccp(450, 210);
		
		_menu = [CCMenu menuWithItems:_colorButton, _incrementButton, _decrementButton, nil];
		_menu.position = ccp(0, 0);
		[self addChild:_menu];
		[self addChild:_blueCountLabel];
		[self addChild:_greenCountLabel];
	}
	return self;
}

@end
