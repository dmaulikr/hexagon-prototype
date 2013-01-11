//
//  Game.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright (c) 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMap.h"
#import "HXGameScene.h"

@interface HXGame : NSObject

@property (nonatomic, strong) HXGameScene *gameScene;
@property (nonatomic, strong) HXMap *map;

- (id)initWithGameScene:(HXGameScene *)gameScene;
- (void)initializeGameScene;

@end
