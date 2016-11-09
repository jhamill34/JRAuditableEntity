//
//  FixableNumber.h
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRBaseFixable.h"
#import "JRVerifiableEntityProtocol.h"

@interface JRFixableNumber : JRBaseFixable

@property (readonly, nonatomic, strong) NSNumber *low;
@property (readonly, nonatomic, strong) NSNumber *high;

- (instancetype)initWithLow:(NSNumber *)low andHigh:(NSNumber *)high forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field;

+ (instancetype)fixableWithLow:(NSNumber *)low andHigh:(NSNumber *)high forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field;

@end
