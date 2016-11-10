//
//  InsertListCommand.m
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRDiffableConstants.h"
#import "JRInsertListCommand.h"

@implementation JRInsertListCommand

- (instancetype) initWithValue:(id)value atIndex:(NSUInteger)ndx{
    if(self = [super init]){
        _value = value;
        _index = ndx;
    }
    
    return self;
}

+ (instancetype)commandWithValue:(id)value atIndex:(NSUInteger)ndx{
    return [[self alloc] initWithValue:value atIndex:ndx];
}

- (void)performCommand:(NSMutableArray *)list withParent:(id)parent withError:(NSError *__autoreleasing *)error{
    if(_index > list.count){
        *error = [NSError errorWithDomain:JRDiffableErrorDomain code:JRDiffableIndexOutOfBounds userInfo:nil];
        return;
    }
    
    // Ask delegate if we want to Insert
    // if YES {
        [list insertObject:_value atIndex:_index];
    // }
}

@end
