//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRPatch.h"


@interface JREntityPatch : NSObject<JRPatch>

@property (readonly, nonatomic, strong) id to;
@property (readonly, nonatomic, strong) Class type;
@property (readonly, nonatomic, strong) NSString *field;

@property (nonatomic, weak) id<JRDiffRunnerDelegate> delegate;

- (instancetype)initWithTo:(id)to type:(Class)type field:(NSString *)field;

+ (instancetype)patchWithTo:(id)to type:(Class)type field:(NSString *)field;


@end
