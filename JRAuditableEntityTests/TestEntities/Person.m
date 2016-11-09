//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import "Person.h"
#import "JRFixableText.h"
#import "JRFixableNumber.h"
#import "JRFixableListItem.h"
#import "JRCompositeFixableEntity.h"

@implementation Person {

}

- (BOOL)isEqual:(Person *)object{
    if(self == object){
        return YES;
    }else if(object == nil || [self class] != [object class]){
        return NO;
    }else{
        return [self._id isEqualToNumber:object._id];
    }
}

- (NSArray<NSString *> *)diffableProperties {
    return @[@"name", @"age", @"equipment"];
}

- (NSArray<id<JRFixable>> *)verify{
    NSMutableArray *fixables = [NSMutableArray array];
    
    JRFixableText *nameFix = [JRFixableText fixableWithRegex:@"^[a-zA-Z]+$" forParent:self andField:@"name"];
    if(![nameFix validate]){
        [fixables addObject:nameFix];
    }
    
    JRFixableNumber *ageFix = [JRFixableNumber fixableWithLow:@0 andHigh:@100 forParent:self andField:@"age"];
    if(![ageFix validate]){
        [fixables addObject:ageFix];
    }
    
    JRFixableListItem *equipmentFix = [JRFixableListItem fixableWithParent:self forField:@"equipment"];
    if(![equipmentFix validate]){
        [fixables addObject:equipmentFix];
    }
    
    return [NSArray arrayWithArray:fixables];
}

@end
