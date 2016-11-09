//
//  FixableNumber.m
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRFixableNumber.h"

@implementation JRFixableNumber

- (instancetype)initWithLow:(NSNumber *)low andHigh:(NSNumber *)high forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field{
    if(self = [super initWithParent:parent forField:field]){
        _low = low;
        _high = high;
    }
    
    return self;
}

+ (instancetype)fixableWithLow:(NSNumber *)low andHigh:(NSNumber *)high forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field{
    return [[self alloc] initWithLow:low andHigh:high forParent:parent andField:field];
}

- (BOOL)validate{
    return (self.value != nil && [self.value compare:self.low] == NSOrderedDescending && [self.value compare:self.high] == NSOrderedAscending);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"must be between %@ and %@", self.low, self.high];
}

@end
