//
//  FixableListItem.h
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRBaseFixable.h"
#import "JRVerifiableEntityProtocol.h"

@interface JRFixableListItem : JRBaseFixable

- (NSUInteger)invalidCount;

- (void)removeObjectFromParentsCollection:(id<JRVerifiableEntityProtocol>)entity;

@end
