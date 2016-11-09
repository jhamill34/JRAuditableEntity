//
//  UpdateListCommand.m
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRUpdateListCommand.h"
#import "JRDiffableConstants.h"

@implementation JRUpdateListCommand

- (instancetype) initWithPatch:(NSArray *)patch atIndex:(NSUInteger)ndx{
    if(self = [super init]){
        _index = ndx;
        _patch = patch;
    }
    
    return self;
}

+ (instancetype) commandWithPatch:(NSArray *)patch atIndex:(NSUInteger)ndx{
    return [[self alloc] initWithPatch:patch atIndex:ndx];
}

- (id)value{
    return _patch;
}

- (void)performCommand:(NSMutableArray<id<JRDiffableEntityProtocol>> *)list withParent:(id)parent withError:(NSError *__autoreleasing *)error{
    if(_index >= list.count){
        *error = [NSError errorWithDomain:DiffableErrorDomain code:DiffableIndexOutOfBounds userInfo:nil];
        return;
    }
    
    for(id<JRPatch> p in _patch){
        [p apply:list[_index] withError:error];
        
        if(error && *error != nil){
            return;
        }
    }
}

@end
