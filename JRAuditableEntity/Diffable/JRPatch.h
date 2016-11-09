//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRDiffRunnerDelegate.h"

@protocol JRDiffableEntityProtocol;

@protocol JRPatch <NSObject>

@property (readonly, nonatomic, strong) Class type;
@property (readonly, nonatomic, strong) NSString *field;
@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;

/**
 * Applies the patch to the entity
 */
- (void)apply:(id<JRDiffableEntityProtocol>)entity withError:(NSError **)error;

@end
