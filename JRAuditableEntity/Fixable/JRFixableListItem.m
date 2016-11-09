//
//  FixableListItem.m
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRFixableListItem.h"

@implementation JRFixableListItem

- (id)value{
    NSMutableArray *invalid = [NSMutableArray array];
    for(id<JRVerifiableEntityProtocol> e in [self.parent valueForKey:self.field]){
        if([e verify].count > 0){
            [invalid addObject:e];
        }
    };
    
    return invalid;
}

- (NSUInteger)invalidCount{
    NSArray *values = self.value;
    return values.count;
}

- (void)removeObjectFromParentsCollection:(id<JRVerifiableEntityProtocol>)entity{
    NSMutableArray *childEntities = [NSMutableArray arrayWithArray:[self.parent valueForKey:self.field]];
    [childEntities removeObject:entity];
    [self.parent setValue:[NSArray arrayWithArray:childEntities] forKey:self.field];
}

- (BOOL)validate{
    NSArray *values = self.value;
    return values.count == 0;
}

- (void)setRelatedAction:(id<JRFixableAction>)relatedAction{
    @throw @"Setting Action for fixable list is not permitted";
}

@end
