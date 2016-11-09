//
//  FixableRunnerDelegate.h
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRVerifiableEntityProtocol.h"

@protocol JRFixableRunnerDelegate <NSObject>

- (id)getFixFor:(id<JRVerifiableEntityProtocol>)entity withField:(NSString *)field andPreviousValue:(id)val;

- (BOOL)invalidValue:(id)value forEntity:(id<JRVerifiableEntityProtocol>)entity withField:(NSString *)field;

@end
