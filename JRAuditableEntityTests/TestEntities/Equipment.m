//
//  Equipment.m
//  DiffableEntity
//
//  Created by Joshua L Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "Equipment.h"
#import "JRFixableText.h"

@implementation Equipment

- (BOOL)isEqual:(Equipment *)object{
    if(self == object){
        return YES;
    }else if(object == nil || [self class] != [object class]){
        return NO;
    }else{
        return [self._id isEqualToNumber:object._id];
    }
}

- (NSArray<NSString *> *)diffableProperties{
    return @[@"make", @"model"];
}

- (NSArray<id<JRFixable>> *)verify{
    NSMutableArray *fixables = [NSMutableArray array];
    
    JRFixableText *makeFix = [JRFixableText fixableWithRegex:@"^.+$" forParent:self andField:@"make"];
    if(![makeFix validate]){
        [fixables addObject:makeFix];
    }
    
    return [NSArray arrayWithArray:fixables];
}

@end
