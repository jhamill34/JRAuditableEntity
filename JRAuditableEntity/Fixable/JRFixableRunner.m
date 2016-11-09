//
//  FixableRunner.m
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import "JRFixableRunner.h"
#import "JRVerifiableEntityProtocol.h"
#import "JRCompositeFixableEntity.h"
#import "JRFixableListItem.h"

@implementation JRFixableRunner

- (void)attemptFixes:(NSArray<id<JRFixable>> *)fixes on:(id<JRVerifiableEntityProtocol>)entity{
    if(self.delegate){
        for(id<JRFixable> f in fixes){
            BOOL attemptFix = YES;
            
            if([f isKindOfClass:[JRCompositeFixableEntity class]]){
                id val = [entity valueForKey:[f field]];
                if(val == nil){
                    val = [[[(JRCompositeFixableEntity *)f type] alloc] init];
                    [entity setValue:val forKey:[f field]];
                }
                
                if([val conformsToProtocol:@protocol(JRVerifiableEntityProtocol)]){
                    NSArray<id<JRFixable>> *fixables = [(id<JRVerifiableEntityProtocol>)val verify];
                    [self attemptFixes:fixables on:val];
                }
            }else if([f isKindOfClass:[JRFixableListItem class]]){
                id list = [entity valueForKey:[f field]];
                
                // Send index when we recursively call
                for(id<JRVerifiableEntityProtocol> e in list){
                    if([e conformsToProtocol:@protocol(JRVerifiableEntityProtocol)]){
                        NSArray<id<JRFixable>> *fixables = [e verify];
                        [self attemptFixes:fixables on:e];
                    }
                }
            }else{
                while(attemptFix){
                    // Need to know where this entity sits in relation to the root
                    id newVal = [self.delegate getFixFor:entity withField:[f field] andPreviousValue:[f value]];
                    [f setNewValue:newVal];
                    if([f validate]){
                        // set the new value on the entity
                        [entity setValue:newVal forKey:[f field]];
                        attemptFix = NO;
                    }else{
                        attemptFix = [self.delegate invalidValue:newVal forEntity:entity withField:[f field]];
                    }
                }
            }
        }
    }
}

@end
