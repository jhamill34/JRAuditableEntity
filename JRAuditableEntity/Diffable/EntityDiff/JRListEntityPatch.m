//
//  ListEntityPatch.m
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRDiffableConstants.h"
#import "JRListEntityPatch.h"
#import "JRDiffableEntityProtocol.h"
#import "JRCommand.h"
#import "JRInsertListCommand.h"
#import "JRDeleteListCommand.h"

@implementation JRListEntityPatch

- (instancetype)initWithParent:(id<JRDiffableEntityProtocol>)parent field:(NSString *)field withCommands:(NSArray<id<JRCommand>> *)commands{
    if(self = [super init]){
        _parent = parent;
        _field = field;
        _listCommands = commands;
    }
    
    return self;
}

+ (instancetype)patchWithParent:(id<JRDiffableEntityProtocol>)parent field:(NSString *)field withCommands:(NSArray<id<JRCommand>> *)commands{
    return [[self alloc] initWithParent:parent field:field withCommands:commands];
    
}

- (Class)type{
    return [NSArray class];
}

- (void)removeCommandsFromList:(NSSet<id<JRCommand>> *)commandSet{
    NSMutableArray *mutableCopy = [NSMutableArray arrayWithArray:_listCommands];

    for(id<JRCommand> c in commandSet){
        [mutableCopy removeObject:c];
    }
    
    _listCommands = [NSArray arrayWithArray:mutableCopy];
}

- (void)removeCommandAtIndex:(NSUInteger)index{
    NSMutableArray *mutableCopy = [NSMutableArray arrayWithArray:_listCommands];
    [mutableCopy removeObjectAtIndex:index];
    _listCommands = [NSArray arrayWithArray:mutableCopy];
}

- (void)apply:(id<JRDiffableEntityProtocol>)entity withError:(NSError *__autoreleasing *)error{
    NSArray *val = [entity valueForKey:_field];
    if(![val isKindOfClass:[NSArray class]]){
        return;
    }
    
    NSInteger correctionCount = 0;
    NSMutableArray *_val = [NSMutableArray arrayWithArray:val];
    for(id<JRCommand> c in _listCommands){
        [c setDelegate:self.delegate];
        BOOL shouldPerform = YES;
        if([c delegate]){
            shouldPerform = [[c delegate] shouldApplyListCommand:c on:_val];
        }
        
        if(shouldPerform){
            [c setIndex:([c index] + correctionCount)];
            [c performCommand:_val withParent:entity withError:error];
        }else{
            if([c isKindOfClass:[JRInsertListCommand class]]){
                correctionCount = correctionCount - 1;
            }else if([c isKindOfClass:[JRDeleteListCommand class]]){
                correctionCount = correctionCount + 1;
            }
        }
        
        if(error && *error != nil){
            return;
        }
    }
    
    [entity setValue:[NSArray arrayWithArray:_val] forKey:_field];
}

@end
