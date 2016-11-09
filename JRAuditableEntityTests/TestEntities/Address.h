//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRDiffableEntityProtocol.h"
#import "JRVerifiableEntityProtocol.h"

@interface Address : NSObject<JRDiffableEntityProtocol, JRVerifiableEntityProtocol>

@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;

@end
