//
//  DiffableEntityTests.m
//  DiffableEntityTests
//
//  Created by Joshua L Rasmussen on 10/28/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Address.h"
#import "Company.h"
#import "JRDiffRunner.h"
#import "JRPatch.h"
#import "JRCommand.h"
#import "JREntityPatch.h"
#import "JRCompositeEntityPatch.h"
#import "JRListEntityPatch.h"
#import "JRInsertListCommand.h"
#import "JRDeleteListCommand.h"
#import "JRUpdateListCommand.h"

@interface AuditableEntityTests : XCTestCase

@end

@implementation AuditableEntityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPersonDiffPropertiesCount{
    Person *p  = [Person new];
    p.name = @"Name";
    p.age = @25;

    Person *p2 = [Person new];
    p2.name = @"Name";
    p2.age = @24;

    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRPatch>> *patches = [dr computeDiff:p against:p2 withError:NULL];
    XCTAssertEqual(1, patches.count);
}

- (void)testPersonDiffPropertiesValue{
    Person *p  = [Person new];
    p.name = @"Name";
    p.age = @25;

    Person *p2 = [Person new];
    p2.name = @"Name";
    p2.age = @24;

    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRPatch>> *patches = [dr computeDiff:p against:p2 withError:NULL];
    JREntityPatch *epatch = (JREntityPatch *)patches[0];

    XCTAssertEqualObjects(@24, epatch.to);
    XCTAssertEqualObjects(@"age", epatch.field);
}

- (void)testErrorGetsSetIfDifferentTypes{
    Person *p  = [Person new];
    p.name = @"Name";
    p.age = @25;

    Address *a = [Address new];

    NSError *error;

    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRPatch>> *patches = [dr computeDiff:p against:a withError:&error];

    XCTAssertNotNil(error);
    XCTAssertNil(patches);
}

- (void)testListDiffOnNumbers{
    NSArray<NSNumber *> *listA = @[@1, @2, @4];
    NSArray<NSNumber *> *listB = @[@1, @3];

    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRCommand>> *commands = [dr computeListDiff:listA against:listB withError:NULL];
    
    XCTAssertEqual(3, commands.count);
    
    XCTAssertEqual([JRDeleteListCommand class], [commands[0] class]);
    XCTAssertEqual(1, [commands[0] index]);
    XCTAssertEqualObjects(@2, [commands[0] value]);

    
    XCTAssertEqual([JRInsertListCommand class], [commands[1] class]);
    XCTAssertEqual(1, [commands[1] index]);
    XCTAssertEqualObjects(@3, [commands[1] value]);

    XCTAssertEqual([JRDeleteListCommand class], [commands[2] class]);
    XCTAssertEqual(2, [commands[2] index]);
    XCTAssertEqualObjects(@4, [commands[2] value]);
}

- (void)testListDiffOnPeople{
    Person *p1 = [Person new];
    p1._id = @1;
    p1.name = @"P1";
    p1.age = @23;
    
    Person *p2 = [Person new];
    p2._id = @2;
    p2.name = @"P2";
    p2.age = @23;
    
    Person *p3 = [Person new];
    p3._id = @3;
    p3.name = @"P3";
    p3.age = @23;
    
    Person *p4 = [Person new];
    p4._id = @4;
    p4.name = @"P4";
    p4.age = @23;
    
    Person *p5 = [Person new];
    p5._id = @2;
    p5.name = @"P5";
    p5.age = @23;
    
    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRCommand>> *commands = [dr computeListDiff:@[p1, p2, p3] against:@[p4, p5] withError:NULL];
    XCTAssertEqual(4, commands.count);
}

- (void)testApplyDiff{
    Person *p1 = [Person new];
    p1._id = @1;
    p1.name = @"P1";
    p1.age = @23;
    
    id<JRPatch> updatePatch = [JREntityPatch patchWithTo:@"P2" type:[NSString class] field:@"name"];
    id<JRPatch> updatePatch_b = [JREntityPatch patchWithTo:@24 type:[NSString class] field:@"age"];

    JRDiffRunner *dr = [JRDiffRunner new];
    
    XCTAssertEqualObjects(@"P1", p1.name);
    XCTAssertEqualObjects(@23, p1.age);
    [dr applyDiff:@[updatePatch, updatePatch_b] on:p1 withError:NULL];
    XCTAssertEqualObjects(@"P2", p1.name);
    XCTAssertEqualObjects(@24, p1.age);
}

- (void)testApplyDiffOnNonExistentField{
    Person *p1 = [Person new];
    p1._id = @1;
    p1.name = @"P1";
    p1.age = @23;
    
    id<JRPatch> updatePatch = [JREntityPatch patchWithTo:@"Hello" type:[NSString class] field:@"unknown"];
    
    NSError *error;
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyDiff:@[updatePatch] on:p1 withError:&error];
    
    XCTAssertNotNil(error);
}

- (void)testApplyDiffOnTypeMismatch{
    Person *p1 = [Person new];
    p1._id = @1;
    p1.name = @"P1";
    p1.age = @23;
    
    id<JRPatch> updatePatch = [JREntityPatch patchWithTo:@2 type:[NSNumber class] field:@"name"];
    
    NSError *error;
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyDiff:@[updatePatch] on:p1 withError:&error];
    
    XCTAssertNotNil(error);
}

- (void)testInsertListCommand{
    NSMutableArray *list = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
    
    id<JRCommand> insertCommand = [JRInsertListCommand commandWithValue:@4 atIndex:2];
    XCTAssertEqualObjects(@3, list[2]);
    
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[insertCommand] on:list withError:NULL];
    
    XCTAssertEqual(4, list.count);
    XCTAssertEqualObjects(@4, list[2]);
    XCTAssertEqualObjects(@3, list[3]);
}

- (void)testInsertOnEmptyList{
    NSMutableArray *list = [NSMutableArray arrayWithArray:@[]];
    id<JRCommand> insertCommand = [JRInsertListCommand commandWithValue:@4 atIndex:0];
    
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[insertCommand] on:list withError:NULL];
    
    XCTAssertEqual(1, list.count);
    XCTAssertEqualObjects(@4, list[0]);
}

- (void)testInsertAtNonExistentIndex{
    NSMutableArray *list = [NSMutableArray arrayWithArray:@[@1, @2]];
    
    id<JRCommand> insertCommand = [JRInsertListCommand commandWithValue:@4 atIndex:4];
    
    NSError *error;
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[insertCommand] on:list withError:&error];
    
    XCTAssertEqual(2, list.count);
    XCTAssertNotNil(error);
}

- (void)testDeleteListCommand{
    NSMutableArray *list = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
    
    id<JRCommand> deleteCommand = [JRDeleteListCommand commandWithValue:nil atIndex:1];
    XCTAssertEqualObjects(@2, list[1]);
    
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[deleteCommand] on:list withError:NULL];
    
    XCTAssertEqual(2, list.count);
    XCTAssertEqualObjects(@3, list[1]);
}

- (void)testDeleteOnNonExistentIndex{
    NSMutableArray *list = [NSMutableArray arrayWithArray:@[@1, @2]];
    
    id<JRCommand> deleteCommand = [JRDeleteListCommand commandWithValue:nil atIndex:2];

    NSError *error;
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[deleteCommand] on:list withError:&error];
    
    XCTAssertEqual(2, list.count);
    XCTAssertNotNil(error);
}

- (void)testOrderDependentListCommands{
    NSMutableArray *list = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
    
    id<JRCommand> deleteCommand = [JRDeleteListCommand commandWithValue:nil atIndex:1];
    id<JRCommand> insertCommand = [JRInsertListCommand commandWithValue:@4 atIndex:1];
    XCTAssertEqualObjects(@2, list[1]);
    
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[deleteCommand, insertCommand] on:list withError:NULL];
    
    XCTAssertEqual(3, list.count);
    XCTAssertEqualObjects(@4, list[1]);
}

- (void)testUpdateListCommand{
    Person *p1 = [Person new];
    p1._id = @1;
    p1.name = @"P1";
    p1.age = @23;
    
    Person *p2 = [Person new];
    p2._id = @2;
    p2.name = @"P2";
    p2.age = @23;
    
    Person *p3 = [Person new];
    p3._id = @3;
    p3.name = @"P3";
    p3.age = @23;
    NSMutableArray<Person *> *list = [NSMutableArray arrayWithArray:@[p1, p2, p3]];

    id<JRPatch> changeName = [JREntityPatch patchWithTo:@"P4" type:[NSString class] field:@"name"];
    id<JRCommand> updateCommand = [JRUpdateListCommand commandWithPatch:@[changeName] atIndex:1];
    
    XCTAssertEqualObjects(@"P2", list[1].name);
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[updateCommand] on:list withError:NULL];
    XCTAssertEqualObjects(@"P4", list[1].name);
}

- (void)testUpdateOnNonExistentIndex{
    Person *p1 = [Person new];
    p1._id = @1;
    p1.name = @"P1";
    p1.age = @23;
    
    Person *p2 = [Person new];
    p2._id = @2;
    p2.name = @"P2";
    p2.age = @23;

    NSMutableArray<Person *> *list = [NSMutableArray arrayWithArray:@[p1, p2]];
    
    id<JRPatch> changeName = [JREntityPatch patchWithTo:@"P4" type:[NSString class] field:@"name"];
    id<JRCommand> updateCommand = [JRUpdateListCommand commandWithPatch:@[changeName] atIndex:2];
    
    NSError *error;
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyListDiff:@[updateCommand] on:list withError:&error];
    XCTAssertEqualObjects(@"P2", list[1].name);
    XCTAssertNotNil(error);
}

- (void)testGenerateCompositeEntityDiff{
    Company *c1 = [Company new];
    c1._id = @1;
    c1.name = @"C1";
    Address *a1 =[Address new];
    a1._id = @2;
    a1.street = @"123";
    c1.address = a1;
    
    Company *c2 = [Company new];
    c2._id = @1;
    c2.name = @"C1";
    Address *a2 = [Address new];
    a2._id = @2;
    a2.street = @"456";
    c2.address = a2;
    
    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRPatch>> *patch = [dr computeDiff:c1 against:c2 withError:NULL];
    XCTAssertEqual(1, patch.count);
}

- (void)testApplyCompositeEntityDiff{
    Company *c1 = [Company new];
    c1._id = @1;
    c1.name = @"C1";
    Address *a1 =[Address new];
    a1._id = @2;
    a1.street = @"123";
    c1.address = a1;
    
    id<JRPatch> addressPatch = [JREntityPatch patchWithTo:@"456" type:[NSString class] field:@"street"];
    id<JRPatch> companyPatch = [JRCompositeEntityPatch patchWithPatches:@[addressPatch] type:[Address class] field:@"address"];
    
    XCTAssertEqualObjects(@"123", c1.address.street);
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyDiff:@[companyPatch] on:c1 withError:NULL];
    XCTAssertEqualObjects(@"456", c1.address.street);
}

- (void)testGenerateCompositeEntityDiffFromNil{
    Company *c1 = [Company new];
    c1._id = @1;
    c1.name = @"C1";
    c1.address = nil;
    
    Company *c2 = [Company new];
    c2._id = @1;
    c2.name = @"C1";
    Address *a2 = [Address new];
    a2._id = @2;
    a2.street = @"456";
    c2.address = a2;
    
    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRPatch>> *patch = [dr computeDiff:c1 against:c2 withError:NULL];
    XCTAssertEqual(1, patch.count);
    XCTAssertEqual([JREntityPatch class], [patch[0] class]);
}

- (void)testGenerateCompositeEntityDiffToNil{
    Company *c1 = [Company new];
    c1._id = @1;
    c1.name = @"C1";
    
    Address *a2 = [Address new];
    a2._id = @2;
    a2.street = @"456";
    c1.address = a2;
    
    Company *c2 = [Company new];
    c2._id = @1;
    c2.name = @"C1";
    c2.address = nil;

    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRPatch>> *patch = [dr computeDiff:c1 against:c2 withError:NULL];
    XCTAssertEqual(1, patch.count);
    XCTAssertEqual([JREntityPatch class], [patch[0] class]);
}

- (void)testApplyCompositeEntityDiffToNil{
    Company *c1 = [Company new];
    c1._id = @1;
    c1.name = @"C1";
    Address *a1 =[Address new];
    a1._id = @2;
    a1.street = @"123";
    c1.address = a1;
    
    id<JRPatch> addressPatch = [JREntityPatch patchWithTo:nil type:[Address class] field:@"address"];
    
    XCTAssertEqualObjects(@"123", c1.address.street);
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyDiff:@[addressPatch] on:c1 withError:NULL];
    XCTAssertNil(c1.address);
}

- (void)testGenerateEntityListPropertiesDiff{
    // Initial Person
    Person *p = [Person new];
    p._id = @1;
    p.name = @"P1";
    
    Equipment *e1 = [Equipment new];
    e1._id = @2;
    e1.make = @"Make1";

    Equipment *e2 = [Equipment new];
    e2._id = @3;
    e2.make = @"Make2";
    
    p.equipment = @[e1, e2];
    
    // Updated Person
    Person *p2 = [Person new];
    p2._id = @1;
    p2.name = @"P1";
    
    Equipment *e3 = [Equipment new];
    e3._id = @2;
    e3.make = @"Make3";
    
    Equipment *e4 = [Equipment new];
    e4._id = @4;
    e4.make = @"Make4";
    
    p2.equipment = @[e3, e4];
    
    JRDiffRunner *dr =[JRDiffRunner new];
    NSArray<id<JRPatch>> *patch = [dr computeDiff:p against:p2 withError:NULL];
    
    XCTAssertEqual(1, patch.count);
    XCTAssertEqual([JRListEntityPatch class], [patch[0] class]);
}

- (void)testGenerateEntityListPropertiesDiffWithEmptyArray{
    // Initial Person
    Person *p = [Person new];
    p._id = @1;
    p.name = @"P1";
    p.equipment = @[];
    
    // Updated Person
    Person *p2 = [Person new];
    p2._id = @1;
    p2.name = @"P1";
    
    Equipment *e3 = [Equipment new];
    e3._id = @2;
    e3.make = @"Make3";
    
    Equipment *e4 = [Equipment new];
    e4._id = @4;
    e4.make = @"Make4";
    
    p2.equipment = @[e3, e4];
    
    JRDiffRunner *dr = [JRDiffRunner new];
    NSArray<id<JRPatch>> *patch = [dr computeDiff:p against:p2 withError:NULL];
    
    XCTAssertEqual(1, patch.count);
    XCTAssertEqual([JRListEntityPatch class], [patch[0] class]);
}

- (void)testApplyEntityListPropertyDiff{
    // Initial Person
    Person *p2 = [Person new];
    p2._id = @1;
    p2.name = @"P1";
    
    Equipment *e3 = [Equipment new];
    e3._id = @2;
    e3.make = @"Make3";
    
    Equipment *e4 = [Equipment new];
    e4._id = @4;
    e4.make = @"Make4";
    
    p2.equipment = @[e3, e4];
    
    // New Equipment
    Equipment *e5 = [Equipment new];
    e5._id = @5;
    e5.make = @"Make5";
    
    id<JRCommand> listCommand = [JRInsertListCommand commandWithValue:e5 atIndex:1];
    id<JRPatch> listPatch = [JRListEntityPatch patchWithParent:p2 field:@"equipment" withCommands:@[listCommand]];
    
    XCTAssertEqualObjects(@"Make4", p2.equipment[1].make);
    JRDiffRunner *dr = [JRDiffRunner new];
    [dr applyDiff:@[listPatch] on:p2 withError:NULL];
    XCTAssertEqualObjects(@"Make5", p2.equipment[1].make);
}

@end
