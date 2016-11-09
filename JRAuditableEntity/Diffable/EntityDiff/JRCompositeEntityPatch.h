//
//  CompositeEntityPatch.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 10/31/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRPatch.h"

@interface JRCompositeEntityPatch : NSObject<JRPatch>

@property (readonly, nonatomic, strong) NSArray<id<JRPatch>> *patches;
@property (readonly, nonatomic, strong) Class type;
@property (readonly, nonatomic, strong) NSString *field;

@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;

- (instancetype)initWithPatches:(NSArray<id<JRPatch>> *)patches type:(Class)type field:(NSString *)field;

+ (instancetype)patchWithPatches:(NSArray<id<JRPatch>> *)patches type:(Class)type field:(NSString *)field;

@end
