//
//  JRAuditableEntity.h
//  JRAuditableEntity
//
//  Created by Joshua L Rasmussen on 11/9/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//
#import <Foundation/Foundation.h>

//! Project version number for JRAuditableEntity.
FOUNDATION_EXPORT double JRAuditableEntityVersionNumber;

//! Project version string for JRAuditableEntity.
FOUNDATION_EXPORT const unsigned char JRAuditableEntityVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JRAuditableEntity/PublicHeader.h>

#import "JRVerifiableEntityProtocol.h"
#import "JRFixable.h"
#import "JRFixableText.h"
#import "JRFixableNumber.h"
#import "JRCompositeFixableEntity.h"
#import "JRFixableListItem.h"
#import "JRFixableRunnerDelegate.h"
#import "JRFixableRunner.h"
#import "JRFixableAction.h"

#import "JRDiffableEntityProtocol.h"
#import "JRDiffRunner.h"
#import "JRPatch.h"
#import "JREntityPatch.h"
#import "JRCommand.h"
#import "JRInsertListCommand.h"
#import "JRDeleteListCommand.h"
#import "JRUpdateListCommand.h"
#import "JRListEntityPatch.h"
#import "JRCompositeEntityPatch.h"
#import "JRDiffableConstants.h"
#import "JRDiffRunnerDelegate.h"


