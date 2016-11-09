//
//  ListEntityPatch.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRPatch.h"
#import "JRCommand.h"

@interface JRListEntityPatch : NSObject<JRPatch>

@property (readonly, nonatomic, strong) id<JRDiffableEntityProtocol> parent;
@property (readonly, nonatomic, strong) NSArray<id<JRCommand>> *listCommands;
@property (readonly, nonatomic, strong) NSString *field;

@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;

- (instancetype)initWithParent:(id<JRDiffableEntityProtocol>)parent field:(NSString *)field withCommands:(NSArray<id<JRCommand>> *)commands;

+ (instancetype)patchWithParent:(id<JRDiffableEntityProtocol>)parent field:(NSString *)field withCommands:(NSArray<id<JRCommand>> *)commands;

- (void)removeCommandsFromList:(NSSet<id<JRCommand>> *)commandSet;

- (void)removeCommandAtIndex:(NSUInteger)index;

@end
