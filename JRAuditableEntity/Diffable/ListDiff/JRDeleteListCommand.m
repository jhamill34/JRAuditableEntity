//
//  DeleteListCommand.m
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRDiffableConstants.h"
#import "JRDeleteListCommand.h"

@implementation JRDeleteListCommand

- (instancetype) initWithValue:(id)value atIndex:(NSUInteger)ndx{
    if(self = [super init]){
        _index = ndx;
        _value = value;
    }
    
    return self;
}

+ (instancetype) commandWithValue:(id)value atIndex:(NSUInteger)ndx{
    return [[self alloc] initWithValue:value atIndex:ndx];
}

- (void)performCommand:(NSMutableArray *)list withParent:(id)parent withError:(NSError *__autoreleasing *)error{
    if(_index >= list.count){
        *error = [NSError errorWithDomain:JRDiffableErrorDomain code:JRDiffableIndexOutOfBounds userInfo:nil];
        return;
    }
    
    // Ask delegate if we can remove
    // if YES {
        [list removeObjectAtIndex:_index];
    // }
}

@end
