//
//  MainLayer.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HexagonMapLayer.h"

@interface MainLayer : CCLayer {
	HexagonMapLayer *_hexLayer;
	
	CCMenu *_menu;
	CCMenuItemImage *_colorButton, *_incrementButton, *_decrementButton;
}

+ (CCScene *)scene;

@end
