//
//  DiffableActionsTests.m
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/3/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRDiffRunnerDelegate.h"
#import "JRDiffRunner.h"
#import "Person.h"
#import "Equipment.h"
#import "JREntityPatch.h"
#import "JRListEntityPatch.h"
#import "JRInsertListCommand.h"
#import "JRDeleteListCommand.h"

@interface DiffableActionsTests : XCTestCase<JRDiffRunnerDelegate>

@end

@implementation DiffableActionsTests{
    NSUInteger _count;
}

- (void)setUp {
    [super setUp];
    _count = 0;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPartialDiffApplication {
    Person *p = [Person new];
    p._id = @1;
    p.name = @"Josh";
    p.age = @23;
    
    id<JRPatch> updateA = [JREntityPatch patchWithTo:@"Josiah" type:[NSString class] field:@"name"];
    id<JRPatch> updateB = [JREntityPatch patchWithTo:@24 type:[NSNumber class] field:@"age"];
    
    XCTAssertEqualObjects(@"Josh", p.name);
    XCTAssertEqualObjects(@23, p.age);
    
    JRDiffRunner *dr = [JRDiffRunner new];
    dr.delegate = self;
    [dr applyDiff:@[updateA, updateB] on:p withError:NULL];
    
    XCTAssertEqualObjects(@"Josh", p.name);
    XCTAssertEqualObjects(@24, p.age);
    XCTAssertEqual(2, _count);
}

- (void)testPartialDiffWithListsDeleteThenInsert{
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
    
    id<JRCommand> deleteCommand = [JRDeleteListCommand commandWithValue:nil atIndex:1];
    id<JRCommand> listCommand = [JRInsertListCommand commandWithValue:e5 atIndex:1];
    id<JRPatch> listPatch = [JRListEntityPatch patchWithParent:p2 field:@"equipment" withCommands:@[deleteCommand, listCommand]];
    
    XCTAssertEqualObjects(@"Make4", p2.equipment[1].make);
    JRDiffRunner *dr = [JRDiffRunner new];
    dr.delegate = self;
    [dr applyDiff:@[listPatch] on:p2 withError:NULL];
    XCTAssertEqualObjects(@"Make4", p2.equipment[1].make);
    XCTAssertEqualObjects(@"Make5", p2.equipment[2].make);
    XCTAssertEqual(3, p2.equipment.count);
}

- (void)testPartialDiffWithListsInsertThenDelete{
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
    
    id<JRCommand> deleteCommand = [JRDeleteListCommand commandWithValue:nil atIndex:2];
    id<JRCommand> listCommand = [JRInsertListCommand commandWithValue:e5 atIndex:1];
    id<JRPatch> listPatch = [JRListEntityPatch patchWithParent:p2 field:@"equipment" withCommands:@[listCommand, deleteCommand]];
    
    XCTAssertEqualObjects(@"Make4", p2.equipment[1].make);
    JRDiffRunner *dr = [JRDiffRunner new];
    dr.delegate = self;
    [dr applyDiff:@[listPatch] on:p2 withError:NULL];
    XCTAssertEqualObjects(@"Make3", p2.equipment[0].make);
    XCTAssertEqual(1, p2.equipment.count);
}


- (BOOL)shouldApplyPatch:(id<JRPatch>)p on:(id<JRDiffableEntityProtocol>)entity{
    _count++;
    if([[p field] isEqualToString:@"name"]){
        return NO;
    }
    return YES;
}

- (BOOL)shouldApplyListCommand:(id<JRCommand>)c on:(NSArray *)list{
    _count++;
    return (_count != 1);
}

@end
