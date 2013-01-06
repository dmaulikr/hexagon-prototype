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
	HexagonMap *_map;
	Hexagon *_selectedHexagon;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender;
- (void)handlePan:(UIPanGestureRecognizer *)sender;

@end
