//
//  UpdateListCommand.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCommand.h"
#import "JRPatch.h"

@interface JRUpdateListCommand : NSObject<JRCommand>

@property NSUInteger index;
@property (readonly, nonatomic, strong) NSArray<id<JRPatch>> *patch;

@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;

- (instancetype) initWithPatch:(NSArray<id<JRPatch>> *)patch atIndex:(NSUInteger)ndx;

+ (instancetype) commandWithPatch:(NSArray<id<JRPatch>> *)patch atIndex:(NSUInteger)ndx;

@end
