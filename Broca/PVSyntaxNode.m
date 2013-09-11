//
//  PVSyntaxNode.m
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVSyntaxNode.h"
#import <objc/runtime.h>

@implementation PVSyntaxNode

@synthesize source, range, children, error, given_name;

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

- (PVSyntaxNode *)childNodeAt:(NSUInteger)index
{
    return (PVSyntaxNode *)[children objectAtIndex:index];
}

- (NSString *)formatForDescription:(NSString *)spaces
{
    NSString *children_str = nil;
    if ([children count]) {
        children_str = @"\n";
        NSString *more_spaces = [NSString stringWithFormat:@"\t%@", spaces];
        for (PVSyntaxNode * child in children) {
            children_str = [NSString stringWithFormat:@"%@%@\n",
                            children_str,
                            [child formatForDescription:more_spaces]];
        }
    } else {
        children_str = @"(none)";
    }
    if (given_name) {
        return [NSString stringWithFormat:@"%@<%s(%@)@0x%X: children:%@>",
                spaces, class_getName([self class]), given_name,
                (unsigned)(void*)self, children_str];
        
    } else {
        return [NSString stringWithFormat:@"%@<%s@0x%X: children:%@>",
                spaces, class_getName([self class]),
                (unsigned)(void*)self, children_str];
    }
    
}
- (NSString *)description
{
    return [self formatForDescription:@""];
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
