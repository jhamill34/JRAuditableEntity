//
//  FixableText.m
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRFixableText.h"

@implementation JRFixableText

- (instancetype)initWithRegex:(NSString *)regex forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field{
    if(self = [super initWithParent:parent forField:field]){
        _regex = regex;
    }
    
    return self;
}

+ (instancetype)fixableWithRegex:(NSString *)regex forParent:(id<JRVerifiableEntityProtocol>)parent andField:(NSString *)field{
    return [[self alloc] initWithRegex:regex forParent:parent andField:field];
}

- (BOOL)validate{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.regex options:0 error:nil];
    NSString *val = self.value;
    
    return (val != nil && [regex firstMatchInString:val options:0 range:NSMakeRange(0, val.length)] != nil);
}

- (NSString *)description{
    if(self.message){
        return self.message;
    }else{
        return [NSString stringWithFormat:@"must follow regex %@", _regex];
    }
}

@end
