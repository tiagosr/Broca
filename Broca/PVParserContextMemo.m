//
//  PVParserContextMemo.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVParserContextMemo.h"
#import "PVSyntaxNode.h"

@implementation PVParserContextMemo

@synthesize position, node;

- (id)initWithNode:(PVSyntaxNode *)_node at:(NSUInteger)pos
{
    self = [super init];
    if (self) {
        position = pos;
        node = _node;
    }
    
    return self;
}
+ (PVParserContextMemo *)withNode:(PVSyntaxNode *)_node at:(NSUInteger)pos
{
    return [[PVParserContextMemo alloc] initWithNode:_node at:pos];
}
@end
