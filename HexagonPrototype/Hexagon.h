//
//  Hexagon.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Hexagon : NSObject

@property (strong) CCSprite *sprite;

- (id)initWithSprite:(CCSprite *)sprite;

@end
