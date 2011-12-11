//
//  BrocaTests.m
//  BrocaTests
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "BrocaTests.h"

@implementation BrocaTests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    
    [super tearDown];
}

- (void)testLiteralParse
{
    PVParser *stringparser = [[PVParser alloc] initWithParserTree:[PVLiteral :@"oi"]];
    PVSyntaxNode *node = [stringparser parseString:@"oi"];
    STAssertNotNil(node, @"Node should be not nil");
    STAssertTrue([node isKindOfClass:[PVSyntaxNode class]], @"Node should be a PVSyntaxNode");
    STAssertNotNil(node.children, @"there should be children within node");
    STAssertTrue([node.children count]==1, @"there should be only one child");
    NSString *child = [node.children objectAtIndex:0];
    STAssertNotNil(child, @"child should not be null");
    STAssertTrue([child isEqualToString:@"oi"], @"child should be the string we search for");
}

@end
