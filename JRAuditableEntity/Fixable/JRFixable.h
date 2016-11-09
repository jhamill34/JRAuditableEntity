//
//  Fixable.h
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRFixableAction.h"

/**
 * Protocol that wraps around an entity to verify a particular 
 * field is valid and allows users to fix the value
 */
@protocol JRFixable <NSObject>

#pragma mark - Display Methods

/**
 * Gets the current value of the field that is being verified
 * 
 * @returns The current value
 */
- (id)value;

/** 
 * The field that is being verified
 * 
 * @returns The field
 */
- (NSString *)field;

#pragma mark - Validation

/**
 * Runs through a validation process. This is implementation specific
 *
 * @returns A Boolean indicating if the value is valid or not
 */
- (BOOL)validate;

#pragma mark - Fix

/**
 * Sets the value of the Fixable entity is validating
 *
 * @param val The new value to validate
 */
- (void)setNewValue:(id)val;

#pragma mark - Fix Action

- (void)setRelatedAction:(id<JRFixableAction>)action;

- (id<JRFixableAction>)relatedAction;

- (void)fix:(id)context withSuccess:(FixableSuccess)success andFailure:(FixableFailure)failure;

@end
