//
//  PVCompiledGrammar.m
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVCompiledGrammar.h"

@implementation PVCompiledGrammar

- (id)initWithParserTree:(PVRule *)_root
{
    self = [super init];
    if (self) {
        root = [_root retain];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithParserTree:[coder decodeObjectForKey:@"root"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:root forKey:@"root"];
}

- (PVSyntaxNode *)parseString:(NSString *)str
{
    PVParserContext *ctx = [[PVParserContext alloc] initWithInput:str memoTable:[NSArray array]];
    PVSyntaxNode *root_node = [[PVSyntaxNode alloc] initWithName:@"root" source:str range:NSMakeRange(0, [str length])];
    [ctx evaluateRule:root parent:root_node];
    return root_node;
}




@end
