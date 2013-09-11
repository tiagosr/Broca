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
    PVParser *stringparser = [[PVParser alloc] initWithParserTree:[PVLiteral :@"oi"]];
    PVSyntaxNode *node = [stringparser parseString:@"oi"];
    PVSyntaxNode *fail = [stringparser parseString:@"tchau"];
    STAssertNotNil(node, @"Node should be not nil");
    STAssertTrue([node isKindOfClass:[PVSyntaxNode class]], @"Node should be a PVSyntaxNode");
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

- (void)testNamedParse
{
    PVParser *stringparser = [[PVParser alloc] initWithParserTree:[PVLiteral named:@"Oi" :@"oi"]];
    PVSyntaxNode *pos_node = [stringparser parseString:@"oi"];
    PVSyntaxNode *neg_node = [stringparser parseString:@"tchau"];
    STAssertNotNil(pos_node, @"Positive test node should not be nil");
    STAssertTrue([pos_node isKindOfClass:[PVSyntaxNode class]], @"Positive test node should be a PVSyntaxNode");
    STAssertTrue([pos_node.given_name isEqualToString:@"Oi"], @"Positive node should be assigned it's name");
    STAssertNotNil(pos_node.children, @"there should be a children array within node");
    STAssertTrue([pos_node.children count]==1, @"there should be only one child node");
    PVSyntaxNode *child = [pos_node childNodeAt:0];
    STAssertNotNil(child, @"positive test child should not be nil");
    STAssertTrue([child isKindOfClass:[NSString class]], @"child node should be a PVSyntaxNode");
    STAssertNotNil(neg_node, @"Negative test node should not be nil");
    STAssertTrue([neg_node.children count]==0, @"negative test node should have no children");
}

@end
