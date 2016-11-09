//
// Created by Joshua L Rasmussen on 10/28/16.
// Copyright (c) 2016 Dealer Information Systems. All rights reserved.
//

#import "Address.h"
#import "JRFixableText.h"

@implementation Address {

}

- (BOOL)isEqual:(Address *)object{
    if(self == object){
        return YES;
    }else if(object == nil || [self class] != [object class]){
        return NO;
    }else{
        return [self._id isEqualToNumber:object._id];
    }
}

- (NSArray<NSString *> *)diffableProperties {
    return @[@"street", @"city"];
}

- (NSArray<id<JRFixable>> *)verify{
    NSMutableArray *fixables = [NSMutableArray array];
    
    JRFixableText *cityFix = [JRFixableText fixableWithRegex:@"^[a-zA-Z]+$" forParent:self andField:@"city"];
    if(![cityFix validate]){
        [fixables addObject:cityFix];
    }
 
    return [NSArray arrayWithArray:fixables];
}

@end
