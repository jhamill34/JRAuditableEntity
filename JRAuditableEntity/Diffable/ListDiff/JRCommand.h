//
//  Command.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRDiffRunnerDelegate.h"

@protocol JRCommand <NSObject>

@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;
@property NSUInteger index;

- (id)value;
- (void)performCommand:(NSMutableArray *)list withParent:(id)parent withError:(NSError **)error;

@end
