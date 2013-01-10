//
//  HexagonMapLayer.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HexagonMap.h"

@interface HexagonMapLayer : CCLayer <UIGestureRecognizerDelegate> {
	Hexagon *_activatedHexagon, *_hexagonTouchBegan, *_hexagonTouchEnded;
}

@property (nonatomic, strong) HexagonMap *map;
@property (nonatomic, strong) NSMutableDictionary *tallies;

- (void)activateHexagon:(Hexagon *)hexagon;
- (void)deactivateHexagon;

- (void)changeColor;
- (void)increment;
- (void)decrement;

#pragma mark Battle Methods

- (void)performBattleBetweenAttacker:(Hexagon *)attacker andDefender:(Hexagon *)defender;
- (void)performRiskyRiskBattleBetweenAttacker:(Hexagon *)attacker andDefender:(Hexagon *)defender;

#pragma mark UIGestureRecognizer Handlers

- (void)handlePinch:(UIPinchGestureRecognizer *)sender;
- (void)handlePan:(UIPanGestureRecognizer *)sender;

@end
