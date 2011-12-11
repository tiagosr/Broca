//
//  PVSyntaxNode.m
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVSyntaxNode.h"

@implementation PVSyntaxNode

@synthesize range, children, error;

#pragma mark - Initialization and deinitialization
- (id)initWithName:(NSString *)name source:(NSString *)str_source range:(NSRange)str_range
{
    self = [super init];
    if (self) {
        range = str_range;
        given_name = [name copy];
        source = str_source;
        children = [NSMutableArray array];
        error = nil;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name source:(NSString *)str_source range:(NSRange)str_range error:(NSString *)err_text
{
    self = [self initWithName:name source:source range:range];
    if (self) {
        error = [err_text copy];
    }
    return self;
}

- (void)dealloc
{
    [children release];
    [error release];
    [given_name release];
    [super dealloc];
}

#pragma mark - Traversal and text

- (void)traverse:(id<PVSyntaxNodeTraverser>)walker
{
    if ([walker enteredNode:self]) {
        for (PVSyntaxNode *child in children) {
            [child traverse:walker];
        }
    }
    [walker exitedNode:self];
}

- (NSString *)innerText
{
    return [source substringWithRange:range];
}

@end
