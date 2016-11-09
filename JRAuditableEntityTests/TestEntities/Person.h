//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRDiffableEntityProtocol.h"
#import "JRVerifiableEntityProtocol.h"
#import "Equipment.h"

@interface Person : NSObject<JRDiffableEntityProtocol, JRVerifiableEntityProtocol>

@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSArray<Equipment *> *equipment;

@end
