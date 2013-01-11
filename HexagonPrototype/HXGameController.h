//
//  GameController.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/10/13.
//  Copyright (c) 2013 kilovolt. All rights reserved.
//

#import "cocos2d.h"
#import "HXGameScene.h"
#import "HXGame.h"

@interface HXGameController : NSObject <HXGameSceneDelegate> {
	HXHexagon *_activatedHexagon, *_hexagonTouchBegan, *_hexagonTouchEnded;
	HXGame *_game;
}

@property (nonatomic, strong) HXGameScene *gameScene;

- (void)activateHexagon:(HXHexagon *)hexagon;
- (void)deactivateHexagon;

#pragma mark -
#pragma mark Battle Methods

- (void)performBattleBetweenAttacker:(HXHexagon *)attacker andDefender:(HXHexagon *)defender;
- (void)performRiskyRiskBattleBetweenAttacker:(HXHexagon *)attacker andDefender:(HXHexagon *)defender;

@end
