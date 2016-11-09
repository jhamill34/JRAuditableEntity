//
//  FixableText.h
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRBaseFixable.h"
#import "JRVerifiableEntityProtocol.h"

@interface JRFixableText : JRBaseFixable

@property (readonly, nonatomic, strong) NSString *regex;
@property (nonatomic, strong) NSString *message;

- (instancetype)initWithRegex:(NSString *)regex forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field;

+ (instancetype)fixableWithRegex:(NSString *)regex forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field;

@end
