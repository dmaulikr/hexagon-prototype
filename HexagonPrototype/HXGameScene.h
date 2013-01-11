//
//  GameScene.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HXMapLayer.h"
#import "HXHUDLayer.h"

@protocol HXGameSceneDelegate

- (void)switchColor;
- (void)increment;
- (void)decrement;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface HXGameScene : CCScene

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) HXHUDLayer *HUDLayer;
@property (nonatomic, strong) HXMapLayer *mapLayer;

- (id)initWithDelegate:(id)delegate;
- (CGPoint)convertToGameSpace:(CGPoint)worldPoint;

@end
