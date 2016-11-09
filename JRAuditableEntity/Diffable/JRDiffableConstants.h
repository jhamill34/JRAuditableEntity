//
//  DiffableConstants.h
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef DiffableConstants_h
#define DiffableConstants_h

typedef NS_ENUM(NSInteger, DiffableErrorCodes) {
    DiffableMismatchType,
    DiffableIndexOutOfBounds,
    DiffableMissingProperty
};

extern NSString *const DiffableErrorDomain;

#endif /* DiffableConstants_h */
