//
//  Company.m
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "Company.h"
#import "JRCompositeFixableEntity.h"

@implementation Company

- (BOOL)isEqual:(Company *)object{
    if(self == object){
        return YES;
    }else if(object == nil || [self class] != [object class]){
        return NO;
    }else{
        return [self._id isEqualToNumber:object._id];
    }
}

- (NSArray<NSString *> *)diffableProperties{
    return @[@"address", @"name"];
}

- (NSArray<id<JRFixable>> *)verify{
    NSMutableArray *validations = [NSMutableArray array];
    
    JRCompositeFixableEntity *addressFix = [JRCompositeFixableEntity fixableWithParent:self forField:@"address" ofType:[Address class]];
    if(![addressFix validate]){
        [validations addObject:addressFix];
    }
    
    return [NSArray arrayWithArray:validations];
}

@end
