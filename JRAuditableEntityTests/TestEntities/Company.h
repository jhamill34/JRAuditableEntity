//
//  Company.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRDiffableEntityProtocol.h"
#import "JRVerifiableEntityProtocol.h"
#import "Address.h"

@interface Company : NSObject<JRDiffableEntityProtocol, JRVerifiableEntityProtocol>

@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Address *address;

@end
