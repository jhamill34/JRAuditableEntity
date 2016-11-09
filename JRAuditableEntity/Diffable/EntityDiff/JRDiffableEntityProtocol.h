//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JRDiffableEntityProtocol <NSObject>

/**
 * returns a list of the properties that are to be compared
 */
- (NSArray<NSString *> *)diffableProperties;

#pragma mark - KVC

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;

@end
