//
//  VerifiableEntityProtocol.h
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRFixable.h"

/**
 * Protocol to indicate that a rule set will be created 
 * that determines when an entity is invalid and how to fix it
 */
@protocol JRVerifiableEntityProtocol <NSObject>

/**
 * Generates the manifest on what is invalid on this entity
 * 
 * @returns A collection of Fixable objects
 */
- (NSArray<id<JRFixable>> *)verify;

/**
 * Forces the implementation of KeyValueCoding
 * 
 * @param value A value to be set on the object
 * @param key The string representation of the property
 */
- (void)setValue:(id)value forKey:(NSString *)key;

/**
 * Forces the implementation of KeyValueCoding
 *
 * @param key A string representation of the property to get
 * @returns The value stored
 */
- (id)valueForKey:(NSString *)key;

@end
