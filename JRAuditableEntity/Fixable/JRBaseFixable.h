//
//  BaseFixable.h
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/8/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRVerifiableEntityProtocol.h"
#import "JRFixable.h"

@interface JRBaseFixable : NSObject<JRFixable>

@property (readonly, nonatomic, strong) id<JRVerifiableEntityProtocol> parent;
@property (readonly, nonatomic, strong) NSString *field;
@property (nonatomic, strong) id<JRFixableAction> relatedAction;

- (instancetype)initWithParent:(id<JRVerifiableEntityProtocol>)parent forField:(NSString *)field;

+ (instancetype)fixableWithParent:(id<JRVerifiableEntityProtocol>)parent forField:(NSString *)field;

@end
