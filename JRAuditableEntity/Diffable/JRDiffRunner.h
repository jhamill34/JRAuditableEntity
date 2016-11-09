//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRPatch;
@protocol JRCommand;
@protocol JRDiffableEntityProtocol;
@protocol JRDiffRunnerDelegate;

// TODO: this should be instantiated allowing us to keep track of the created diff.
// Limit to top level root object and list compares/apply should be private
@interface JRDiffRunner : NSObject

@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;

#pragma mark - Calculate Diff

/**
 * returns a collection of patch objects associated with entity
 */
- (NSArray <id <JRPatch>> *)computeDiff:(id<JRDiffableEntityProtocol>)entityA against:(id<JRDiffableEntityProtocol>)entityB withError:(NSError **)error;

/**
 * Computes a diff of the two lists
 */
- (NSArray<id<JRCommand>> *)computeListDiff:(NSArray *)listA against:(NSArray *)listB withError:(NSError **)error;

#pragma mark - Apply Diff

/**
 *
 */
- (void)applyDiff:(NSArray<id<JRPatch>> *)patch on:(id<JRDiffableEntityProtocol>)entity withError:(NSError **)error;

/**
 *
 */
- (void)applyListDiff:(NSArray<id<JRCommand>> *)patch on:(NSMutableArray *)list withError:(NSError **)error;

@end
