//
//  HUDLayer.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HXHUDLayer : CCLayer {
	id _delegate;
	CCMenu *_menu;
	CCMenuItemSprite *_colorButton, *_incrementButton, *_decrementButton;
}

@property (nonatomic, strong) CCLabelTTF *blueCountLabel;
@property (nonatomic, strong) CCLabelTTF *greenCountLabel;

- (id)initWithDelegate:(id)delegate;

@end
