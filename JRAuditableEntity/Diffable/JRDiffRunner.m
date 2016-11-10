//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import <objc/runtime.h>
#import "JRDiffableConstants.h"

#import "JRDiffRunner.h"
#import "JRPatch.h"
#import "JRCommand.h"
#import "JRDiffableEntityProtocol.h"
#import "JREntityPatch.h"
#import "JRCompositeEntityPatch.h"
#import "JRListEntityPatch.h"
#import "JRUpdateListCommand.h"
#import "JRInsertListCommand.h"
#import "JRDeleteListCommand.h"

NSInteger max(NSInteger a, NSInteger b){
    if(a >= b){
        return a;
    }else{
        return b;
    }
}

@implementation JRDiffRunner {

}

- (NSArray <id <JRPatch>> *)computeDiff:(id<JRDiffableEntityProtocol>)entityA against:(id<JRDiffableEntityProtocol>)entityB withError:(NSError **)error {
    if([entityA class] != [entityB class]){
        *error = [NSError errorWithDomain:JRDiffableErrorDomain code:JRDiffableMismatchType userInfo:nil];
        return nil;
    }

    NSMutableArray *result = [NSMutableArray array];

    id valA, valB;
    for(NSString *diffableProp in [entityA diffableProperties]){
        valA = [entityA valueForKey:diffableProp];
        valB = [entityB valueForKey:diffableProp];
        id<JRPatch> currentPatch;
        if([valA isKindOfClass:[NSArray class]] && [valB isKindOfClass:[NSArray class]]){
            NSArray<id<JRCommand>> *listCommands = [self computeListDiff:valA against:valB withError:NULL];
            if(listCommands.count > 0){
                currentPatch = [JRListEntityPatch patchWithParent:entityA field:diffableProp withCommands:listCommands];
                [currentPatch setDelegate:self.delegate];
                [result addObject:currentPatch];
            }
        }else if(!(valA == nil && valB == nil) && ![valA isEqual:valB]){
            currentPatch = [JREntityPatch patchWithTo:valB type:[valB class] field:diffableProp];
            [currentPatch setDelegate:self.delegate];
            [result addObject:currentPatch];
        }else if([valA conformsToProtocol:@protocol(JRDiffableEntityProtocol)]){
            NSArray<id<JRPatch>> *patches = [self computeDiff:valA against:valB withError:error];
            if(patches.count > 0){
                currentPatch = [JRCompositeEntityPatch patchWithPatches:patches type:[valB class] field:diffableProp];
                [currentPatch setDelegate:self.delegate];
                [result addObject:currentPatch];
            }
        }
    }

    return [NSArray arrayWithArray:result];
}

- (NSArray <id <JRCommand>> *)computeListDiff:(NSArray *)listA against:(NSArray *)listB withError:(NSError **)error {
    // Allocate rows
    NSInteger **opt = (NSInteger **)malloc(sizeof(NSInteger) * (listA.count + 1));
    NSInteger i, j;

    // Allocate columns and set to 0
    for(i = 0; i <= listA.count; i++){
        opt[i] = (NSInteger *)malloc(sizeof(NSInteger) * (listB.count + 1));
        opt[i][0] = -1 * i;
        for(j = 1; j <= listB.count; j++){
            opt[i][j] = 0;
        }
    }

    // Preset the first row
    for(i = 0; i <= listB.count; i++){
        opt[0][i] = -1 * i;
    }

    // Computation here
    for(i = 1; i <= listA.count; i++){
        for(j = 1; j <= listB.count; j++){
            NSInteger match = -1;
            id aVal, bVal;
            aVal = listA[(NSUInteger)(i - 1)];
            bVal = listB[(NSUInteger)(j - 1)];
            if([aVal isEqual:bVal]){
                match = 2;
            }

            NSInteger prevMax = max(opt[i][j - 1] - 1, opt[i - 1][j] - 1);
            prevMax = max(prevMax, opt[i - 1][j - 1] + match);

            opt[i][j] = prevMax;
        }
    }

    i = listA.count;
    j = listB.count;
    NSMutableArray<id<JRCommand>> *commands = [NSMutableArray array];
    id<JRCommand> newCommand;
    while(i > 0 || j > 0){
        if(i > 0 && j > 0 && (opt[i][j] - opt[i - 1][j - 1]) == 2 && opt[i - 1][j - 1] >= opt[i - 1][j] && opt[i - 1][j - 1] >= opt[i][j - 1]){
            id valA, valB;
            valA = listA[(NSUInteger)(i - 1)];
            valB = listB[(NSUInteger)(j - 1)];
            if([valA conformsToProtocol:@protocol(JRDiffableEntityProtocol)] && [valB conformsToProtocol:@protocol(JRDiffableEntityProtocol)]){
                NSArray<id<JRPatch>> *patch = [self computeDiff:valA against:valB withError:NULL];
                
                if(patch.count > 0){
                    newCommand = [JRUpdateListCommand commandWithPatch:patch atIndex:(NSUInteger)(j - 1)];
                    [newCommand setDelegate:self.delegate];
                    [commands insertObject:newCommand atIndex:0];
                }
            }

            i--;
            j--;
        }else if(j > 0 && (i == 0 || opt[i - 1][j] <= opt[i][j - 1])){
            newCommand = [JRInsertListCommand commandWithValue:listB[(NSUInteger)(j - 1)] atIndex:(j - 1)];
            [newCommand setDelegate:self.delegate];
            [commands insertObject:newCommand atIndex:0];
            j--;
        }else{
            newCommand = [JRDeleteListCommand commandWithValue:listA[(NSUInteger)(i - 1)] atIndex:j];
            [newCommand setDelegate:self.delegate];
            [commands insertObject:newCommand atIndex:0];
            // Delete at index j
            i--;
        }
    }
    
    // Don't forget to free allocated otherwise we'll have a huge leak!!!!
    return [NSArray arrayWithArray:commands];
}

- (void)applyDiff:(NSArray<id<JRPatch>> *)patch on:(id<JRDiffableEntityProtocol>)entity withError:(NSError **)error{
    for(id<JRPatch> p in patch){
        [p setDelegate:self.delegate];
        [p apply:entity withError:error];
        if(error && *error){
            return;
        }
    }
}

- (void)applyListDiff:(NSArray<id<JRCommand>> *)patch on:(NSMutableArray *)list withError:(NSError **)error{
    for(id<JRCommand> c in patch){
        [c performCommand:list withParent:nil withError:error];
        if(error && *error != nil){
            return;
        }
    }
}

@end
