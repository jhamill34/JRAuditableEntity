//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import "JRDiffableConstants.h"
#import "JREntityPatch.h"
#import "JRDiffableEntityProtocol.h"

@implementation JREntityPatch {

}

#pragma mark - Constructors

- (instancetype)initWithTo:(id)to type:(Class)type field:(NSString *)field {
    self = [super init];
    if (self) {
        _to = to;
        _type = type;
        _field = field;
    }

    return self;
}

+ (instancetype)patchWithTo:(id)to type:(Class)type field:(NSString *)field {
    return [[self alloc] initWithTo:to type:type field:field];
}

#pragma mark - Patch

- (void)apply:(id <JRDiffableEntityProtocol>)entity withError:(NSError *__autoreleasing *)error{
    SEL getter = NSSelectorFromString(_field);
    if(![entity respondsToSelector:getter]){
        *error = [NSError errorWithDomain:JRDiffableErrorDomain code:JRDiffableMissingProperty userInfo:nil];
        return;
    }
    
    id val = [entity valueForKey:_field];
    if([val class] != [_to class] && val != nil && _to != nil){
        *error = [NSError errorWithDomain:JRDiffableErrorDomain code:JRDiffableMismatchType userInfo:nil];
        return;
    }
    
    BOOL shouldApplyPatch = YES;
    if(self.delegate){
        shouldApplyPatch = [self.delegate shouldApplyPatch:self on:entity];
    }
    
    if(shouldApplyPatch){
        [entity setValue:_to forKey:_field];
    }
}

@end
