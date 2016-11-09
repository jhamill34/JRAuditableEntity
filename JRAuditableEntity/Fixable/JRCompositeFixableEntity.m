//
//  CompositeFixableEntity.m
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRCompositeFixableEntity.h"
#import "JRFixable.h"

@implementation JRCompositeFixableEntity{
}

- (instancetype)initWithParent:(id<JRVerifiableEntityProtocol>)value forField:(NSString *)field ofType:(Class)type{
    if(self = [super initWithParent:value forField:field]){
        _type = type;
    }
    
    return self;
}

+ (instancetype)fixableWithParent:(id<JRVerifiableEntityProtocol>)value forField:(NSString *)field ofType:(Class)type{
    return [[self alloc] initWithParent:value forField:field ofType:type];
}

- (BOOL)validate{
    id val = self.value;
    NSArray<id<JRFixable>> *subFixes;
    if([val conformsToProtocol:@protocol(JRVerifiableEntityProtocol)]){
        subFixes = [val verify];
    }else{
        subFixes = @[];
    }

    return (subFixes.count == 0) && (val != nil);
}

- (void)setRelatedAction:(id<JRFixableAction>)relatedAction{
    @throw @"Setting custom action for a composite fix is not permitted";
}

@end
