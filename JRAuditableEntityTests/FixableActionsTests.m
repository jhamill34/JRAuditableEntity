//
//  FixableActionsTests.m
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRFixable.h"
#import "JRFixableText.h"
#import "JRFixableNumber.h"
#import "JRCompositeFixableEntity.h"
#import "JRFixableListItem.h"
#import "Person.h"
#import "Company.h"
#import "Address.h"
#import "JRFixableRunner.h"
#import "JRFixableRunnerDelegate.h"

@interface FixableActionsTests : XCTestCase<JRFixableRunnerDelegate>

@end

@implementation FixableActionsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFixableTextAction {
    Person *p = [Person new];
    p.name = @"j05h"; // <- invalid
    
    id<JRFixable> nameFix = [JRFixableText fixableWithRegex:@"^[a-zA-Z]+$" forParent:p andField:@"name"];
    
    JRFixableRunner *fr = [JRFixableRunner new];
    fr.delegate = self;
    [fr attemptFixes:@[nameFix] on:p];
    XCTAssertEqualObjects(@"Josh", p.name);
}

- (void)testFixableNumberAction{
    Person *p = [Person new];
    p.age = @150;
    
    id<JRFixable> ageFix = [JRFixableNumber fixableWithLow:@0 andHigh:@100 forParent:p andField:@"age"];
    
    JRFixableRunner *fr = [JRFixableRunner new];
    fr.delegate = self;
    [fr attemptFixes:@[ageFix] on:p];
    
    XCTAssertEqualObjects(@23, p.age);
}

- (void)testFixableMultipleFields{
    Person *p = [Person new];
    p.age = @150;
    p.name = @"j05h";
    
    id<JRFixable> ageFix = [JRFixableNumber fixableWithLow:@0 andHigh:@100 forParent:p andField:@"age"];
    id<JRFixable> nameFix = [JRFixableText fixableWithRegex:@"^[a-zA-Z]+$" forParent:p andField:@"name"];
    
    JRFixableRunner *fr = [JRFixableRunner new];
    fr.delegate = self;
    [fr attemptFixes:@[ageFix, nameFix] on:p];
    
    XCTAssertEqualObjects(@23, p.age);
    XCTAssertEqualObjects(@"Josh", p.name);
}

- (void)testFixableCompositeEntityAction{
    Company *c = [Company new];
    c._id = @1;
    c.name = @"Name";
    Address *a = [Address new];
    a._id = @2;
    a.city = @"B123";
    c.address = a;
    
    id<JRFixable> addressFix = [JRCompositeFixableEntity fixableWithParent:c forField:@"address" ofType:[Address class]];
    
    JRFixableRunner *fr = [JRFixableRunner new];
    fr.delegate = self;
    [fr attemptFixes:@[addressFix] on:c];
    
    XCTAssertEqualObjects(@"Bellingham", c.address.city);
}

- (void)testFixableCompositeEntityActionWhenNil{
    Company *c = [Company new];
    c._id = @1;
    c.name = @"Name";
    c.address = nil;
    
    id<JRFixable> addressFix = [JRCompositeFixableEntity fixableWithParent:c forField:@"address" ofType:[Address class]];
    
    JRFixableRunner *fr = [JRFixableRunner new];
    fr.delegate = self;
    [fr attemptFixes:@[addressFix] on:c];
    
    XCTAssertEqualObjects(@"Bellingham", c.address.city);
}

- (void)testFixableList{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Name";
    p.age = @23;
    
    Equipment *e = [Equipment new];
    e._id = @2;
    e.make = @"Make1";
    
    Equipment *e2 = [Equipment new];
    e2._id = @2;
    e2.make = @"";
    
    Equipment *e3 = [Equipment new];
    e3._id = @3;
    e3.make = nil;
    
    p.equipment = @[e, e2, e3];
    
    id<JRFixable> equipmentFix = [JRFixableListItem fixableWithParent:p forField:@"equipment"];
    
    JRFixableRunner *fr = [JRFixableRunner new];
    fr.delegate = self;
    [fr attemptFixes:@[equipmentFix] on:p];
    
    XCTAssertEqualObjects(@"Make1", p.equipment[0].make);
    XCTAssertEqualObjects(@"MAKE", p.equipment[1].make);
    XCTAssertEqualObjects(@"MAKE", p.equipment[2].make);
    
}

- (id)getFixFor:(id<JRVerifiableEntityProtocol>)entity withField:(NSString *)field andPreviousValue:(id)val{
    if([field isEqualToString:@"name"]){
        return @"Josh";
    }else if([field isEqualToString:@"age"]){
        return @23;
    }else if([field isEqualToString:@"city"]){
        return @"Bellingham";
    }else if([field isEqualToString:@"make"]){
        return @"MAKE";
    }
    
    return nil;
}

- (BOOL)invalidValue:(id)value forEntity:(id<JRVerifiableEntityProtocol>)entity withField:(NSString *)field{
    return NO;
}

@end
