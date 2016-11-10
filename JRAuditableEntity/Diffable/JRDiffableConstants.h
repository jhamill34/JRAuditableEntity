//
//  DiffableConstants.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef JRDiffableConstants_h
#define JRDiffableConstants_h

typedef NS_ENUM(NSInteger, JRDiffableErrorCodes) {
    JRDiffableMismatchType,
    JRDiffableIndexOutOfBounds,
    JRDiffableMissingProperty
};

extern NSString *const JRDiffableErrorDomain;

#endif /* DiffableConstants_h */
