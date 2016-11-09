//
//  CompositeEntityPatch.m
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRCompositeEntityPatch.h"
#import "JRDiffableEntityProtocol.h"

@implementation JRCompositeEntityPatch


- (instancetype)initWithPatches:(NSArray<id<JRPatch>> *)patches type:(Class)type field:(NSString *)field{
    if(self = [super init]){
        _patches = patches;
        _type = type;
        _field = field;
    }
    
    return self;
}

+ (instancetype)patchWithPatches:(NSArray<id<JRPatch>> *)patches type:(Class)type field:(NSString *)field{
    return [[self alloc] initWithPatches:patches type:type field:field];
}

- (void)apply:(id<JRDiffableEntityProtocol>)entity withError:(NSError *__autoreleasing *)error{
    for(id<JRPatch> p in _patches){
        [p setDelegate:self.delegate];
        id valueAtField = [entity valueForKey:_field];
        [p apply:valueAtField withError:error];
        
        if(error && *error != nil){
            return;
        }
    }
}

@end
