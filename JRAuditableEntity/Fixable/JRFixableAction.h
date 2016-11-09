//
//  FixableAction.h
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/8/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRFixable;

typedef void(^FixableSuccess)(id value);
typedef void(^FixableFailure)(id value, NSString *reason);

/**
 * Implement this protocol to create custom actions for fixing invalid properties
 */
@protocol JRFixableAction <NSObject>

/**
 * Method gets called to retrieve a new value
 * 
 * @param context The context in which the method is called with respect to
 * @param success A call back that gets executed on successful retrieval
 */
- (void)execute:(id)context withFixable:(id<JRFixable>)fix andSuccess:(FixableSuccess)success andFailure:(FixableFailure)failure;

@end
