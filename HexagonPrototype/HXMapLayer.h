//
//  HexagonMapLayer.h
//  HexagonPrototype
//
//  Created by Kyle Stevens on 1/4/13.
//  Copyright 2013 kilovolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HXMap.h"

@interface HXMapLayer : CCLayer <UIGestureRecognizerDelegate> {
	id _delegate;
}

@property (nonatomic, strong) CCSpriteBatchNode *batchNode;

- (id)initWithDelegate:(id)delegate;

#pragma mark -
#pragma mark UIGestureRecognizer Handlers

- (void)handlePinch:(UIPinchGestureRecognizer *)sender;
- (void)handlePan:(UIPanGestureRecognizer *)sender;

@end
