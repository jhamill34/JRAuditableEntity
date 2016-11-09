//
//  DiffRunnerDelegate.h
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRPatch;
@protocol JRCommand;
@protocol JRDiffableEntityProtocol;

@protocol JRDiffRunnerDelegate <NSObject>

/**
 * Delegates responsibility of choosing patch to another object
 * For example, the application of a patch could be delegated to a
 * ViewController where an alert could be poped up for each one or put into a list
 */
- (BOOL)shouldApplyPatch:(id<JRPatch>)p on:(id<JRDiffableEntityProtocol>)entity;

/** 
 * Delegates responsibility of choosing list commands to another object
 */
- (BOOL)shouldApplyListCommand:(id<JRCommand>)c on:(NSArray *)list;

@end
