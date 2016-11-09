//
//  VerifiableEntityTests.m
//  AuditableEntity
//
//  Created by Joshua Rasmussen on 11/1/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Company.h"
#import "Address.h"
#import "JRFixableText.h"
#import "JRFixableNumber.h"
#import "JRCompositeFixableEntity.h"

@interface VerifiableEntityTests : XCTestCase

@end

@implementation VerifiableEntityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGenerateVerifiedEntity {
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Name";
    p.age = @23;
    p.equipment = @[];
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(0, verified.count);
}

- (void)testGenerateFixableText{
    Person *p = [Person new];
    p._id = @1;
    p.name = nil; // <- Explicit
    p.age = @23;
    p.equipment = @[];
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(1, verified.count);
    XCTAssertEqual([JRFixableText class], [verified[0] class]);
}

- (void)testGenerateFixableNumber{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Name";
    p.age = nil; // <- Explicit
    p.equipment = @[];
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(1, verified.count);
    XCTAssertEqual([JRFixableNumber class], [verified[0] class]);
}

- (void)testGenerateFixableTextFailRegex{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"j05h"; // <- Explicit
    p.age = @23;
    p.equipment = @[];
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(1, verified.count);
    XCTAssertEqual([JRFixableText class], [verified[0] class]);
}

- (void)testGenerateFixableNumberOutOfRange{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Name";
    p.age = @150; // <- Explicit
    p.equipment = @[];
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(1, verified.count);
    XCTAssertEqual([JRFixableNumber class], [verified[0] class]);
}

- (void)testGenerateCompositeFixableEntityForNil{
    Company *c = [Company new];
    c._id = @1;
    c.name = @"company";
    c.address = nil;
    
    NSArray<id<JRFixable>> *verified = [c verify];
    XCTAssertEqual(1, verified.count);
    XCTAssertEqual([JRCompositeFixableEntity class], [verified[0] class]);
}

- (void)testValidCompositeEntities{
    Company *c = [Company new];
    c._id = @1;
    c.name = @"company";
    
    Address *a = [Address new];
    a.city = @"Bellingham";
    c.address = a;
    
    NSArray<id<JRFixable>> *verified = [c verify];
    XCTAssertEqual(0, verified.count);
}

- (void)testInvalidCompositeEntitiesNotNil{
    Company *c = [Company new];
    c._id = @1;
    c.name = @"company";
    
    Address *a = [Address new];
    a.city = @"B123";
    c.address = a;
    
    NSArray<id<JRFixable>> *verified = [c verify];
    XCTAssertEqual(1, verified.count);
    XCTAssertEqual([JRCompositeFixableEntity class], [verified[0] class]);
}

- (void)testGenerateFixableListsValid{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Name";
    p.age = @23;
    
    Equipment *e = [Equipment new];
    e.make = @"Make";
    
    Equipment *e2 = [Equipment new];
    e2.make = @"Make2";
    p.equipment = @[e, e2];
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(0, verified.count);
}

- (void)testGenerateFixableListsWithTwoInvalid{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Name";
    p.age = @23;
    
    Equipment *e = [Equipment new];
    e.make = @"Make";
    
    Equipment *e2 = [Equipment new];
    e2.make = nil;
    
    Equipment *e3 = [Equipment new];
    e3.make = @"";
    p.equipment = @[e, e2, e3];
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(1, verified.count);
}

- (void)testGenerateFixableListWithNil{
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Name";
    p.age = @23;
    
    NSArray<id<JRFixable>> *verified = [p verify];
    XCTAssertEqual(0, verified.count);
}

@end
