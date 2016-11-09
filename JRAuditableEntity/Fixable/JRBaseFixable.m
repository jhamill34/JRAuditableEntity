//
//  BaseFixable.m
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/8/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRBaseFixable.h"
#import "JRVerifiableEntityProtocol.h"
#import "JRFixableAction.h"

@implementation JRBaseFixable

- (instancetype)initWithParent:(id<JRVerifiableEntityProtocol>)parent forField:(NSString *)field{
    if(self = [super init]){
        _parent = parent;
        _field = field;
    }
    
    return self;
}

+ (instancetype)fixableWithParent:(id<JRVerifiableEntityProtocol>)parent forField:(NSString *)field{
    return [[self alloc] initWithParent:parent forField:field];
}

- (void)setNewValue:(id)val{
    [_parent setValue:val forKey:_field];
}

- (id)value{
    return [_parent valueForKey:_field];
}

- (BOOL)validate{
    return NO;
}

- (void)fix:(id)context withSuccess:(FixableSuccess)success andFailure:(FixableFailure)failure{
    if(_relatedAction){
        [_relatedAction execute:context withFixable:self andSuccess:success andFailure:failure];
    }
}

@end
