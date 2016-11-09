//
//  CompositeFixableEntity.h
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRBaseFixable.h"
#import "JRVerifiableEntityProtocol.h"
#import "JRFixableRunnerDelegate.h"

@interface JRCompositeFixableEntity : JRBaseFixable

@property (readonly, nonatomic, strong) Class type;

- (instancetype)initWithParent:(id<JRVerifiableEntityProtocol>)value forField:(NSString *)field ofType:(Class)type;

+ (instancetype)fixableWithParent:(id<JRVerifiableEntityProtocol>)value forField:(NSString *)field ofType:(Class)type;

@end
