//
//  BrocaTests.m
//  BrocaTests
//
//  Created by Tiago Rezende on 9/10/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import "BrocaTests.h"
#import "PVLiteral.h"

@implementation BrocaTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLiteralParse
{
    PVRuleSet *ruleset = [PVRuleSet ruleset];
    [ruleset setRuleNamed:@"Oi" :[PVLiteral :@"oi"]];
    PVParser *stringparser = [[PVParser alloc] initWithRuleSet:ruleset];
    PVSyntaxNode *node = [stringparser parseString:@"oi" fromRule:@"Oi"];
    PVSyntaxNode *fail = [stringparser parseString:@"tchau" fromRule:@"Oi"];
    STAssertNotNil(node, @"Node should be not nil");
    STAssertTrue([node isKindOfClass:[PVSyntaxNode class]], @"Node should be a PVSyntaxNode");
    STAssertTrue([node.given_name isEqualToString:@"Oi"], @"Node name should be equal to matched rule");
    STAssertNotNil(node.children, @"there should be children within node");
    STAssertTrue([node.children count]==1, @"there should be only one child");
    STAssertNil(node.error, @"error within node should be nil");
    NSString *child = [node.children objectAtIndex:0];
    STAssertNotNil(child, @"child should not be nil");
    STAssertTrue([child isEqualToString:@"oi"], @"child should be the string we search for");
    STAssertNotNil(fail, @"negative test node should be not nil");
    STAssertTrue([fail isKindOfClass:[PVSyntaxNode class]], @"negative test node should be a PVSyntaxNode");
    STAssertNotNil(fail.children, @"there should be a children array within negative node");
    STAssertTrue([fail.children count]==0, @"there should be no children in negative node");
    
}

@end
