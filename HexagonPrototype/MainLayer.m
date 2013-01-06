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
		_colorButton = [CCMenuItemImage itemWithNormalImage:@"color-button.png"
											  selectedImage:@"color-button-selected.png"
											  disabledImage:@"color-button.png"
													 target:_hexLayer
												   selector:@selector(changeColor)];
		_colorButton.position = ccp(450, 280);
		_colorButton.scale = 0.5;
		
		_incrementButton = [CCMenuItemImage itemWithNormalImage:@"increment-button.png"
												  selectedImage:@"increment-button-selected.png"
												  disabledImage:@"increment-button.png"
														 target:_hexLayer
													   selector:@selector(increment)];
		_incrementButton.position = ccp(450, 160);
		_incrementButton.scale = 0.5;
		
		_decrementButton = [CCMenuItemImage itemWithNormalImage:@"decrement-button.png"
												  selectedImage:@"decrement-button-selected.png"
												  disabledImage:@"decrement-button.png"
														 target:_hexLayer
													   selector:@selector(decrement)];
		_decrementButton.position = ccp(450, 40);
		_decrementButton.scale = 0.5;
		
		_menu = [CCMenu menuWithItems:_colorButton, _incrementButton, _decrementButton, nil];
		_menu.position = ccp(0, 0);
		[self addChild:_menu];
	}
	return self;
}

@end
