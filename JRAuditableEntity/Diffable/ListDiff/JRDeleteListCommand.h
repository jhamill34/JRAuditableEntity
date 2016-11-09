//
//  DeleteListCommand.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRCommand.h"

@interface JRDeleteListCommand : NSObject<JRCommand>

@property NSUInteger index;
@property (readonly, nonatomic, strong) id value;

@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;

- (instancetype) initWithValue:(id)value atIndex:(NSUInteger)ndx;

+ (instancetype) commandWithValue:(id)value atIndex:(NSUInteger)ndx;

@end
