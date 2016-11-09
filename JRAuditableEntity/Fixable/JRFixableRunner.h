//
//  FixableRunner.h
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRFixableRunnerDelegate.h"
#import "JRFixable.h"
#import "JRVerifiableEntityProtocol.h"

@interface JRFixableRunner : NSObject

@property (nonatomic, weak) id<JRFixableRunnerDelegate> delegate;

- (void)attemptFixes:(NSArray<id<JRFixable>> *)fixes on:(id<JRVerifiableEntityProtocol>)entity;

@end
