//
//  FixableActionsInvalidTests.m
//  AuditableEntity
//
//  Created by Joshua L Rasmussen on 11/2/16.
//  Copyright © 2016 Dealer Information Systems. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JRFixableRunner.h"
#import "JRFixableRunnerDelegate.h"
#import "Person.h"
#import "JRFixable.h"
#import "JRFixableText.h"

@interface FixableActionsInvalidTests : XCTestCase<JRFixableRunnerDelegate>

@end

@implementation FixableActionsInvalidTests{
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

- (void)testInvalidResponseToTextFix {
    Person *p = [Person new];
    p.name = @"j123"; // <- invalid
    
    id<JRFixable> nameFix = [JRFixableText fixableWithRegex:@"^[a-zA-Z]+$" forParent:p andField:@"name"];
    
    JRFixableRunner *fr = [JRFixableRunner new];
    fr.delegate = self;
    [fr attemptFixes:@[nameFix] on:p];
    XCTAssertEqualObjects(@"Josh", p.name);
    XCTAssertEqual(2, _count);
}

- (id)getFixFor:(id<JRVerifiableEntityProtocol>)entity withField:(NSString *)field andPreviousValue:(id)val{
    _count = _count + 1;

    if(_count < 2){
        return @"j05h";
    }else{
        return @"Josh";
    }
}

- (BOOL)invalidValue:(id)value forEntity:(id<JRVerifiableEntityProtocol>)entity withField:(NSString *)field{
    return YES;
}

@end
