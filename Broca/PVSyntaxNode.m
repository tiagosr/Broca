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

@synthesize source, range, children, error, name;

#pragma mark - Initialization and deinitialization
- (id)initWithName:(NSString *)_name source:(NSString *)str_source range:(NSRange)str_range
{
    self = [super init];
    if (self) {
        range = str_range;
        name = [_name copy];
        source = str_source;
        children = [NSMutableArray array];
        error = nil;
    }
    
    return self;
}

- (id)initWithName:(NSString *)_name source:(NSString *)str_source range:(NSRange)str_range error:(NSString *)err_text
{
    self = [self initWithName:_name source:source range:range];
    if (self) {
        error = [err_text copy];
    }
    return self;
}

- (void)dealloc
{
    [children release];
    [error release];
    [name release];
    [super dealloc];
}

- (PVSyntaxNode *)childNodeAt:(NSUInteger)index
{
    return (PVSyntaxNode *)[children objectAtIndex:index];
}

- (void)removeChildrenAfter:(NSUInteger)index
{
    NSUInteger len = [children count]-index;
    if (len) {
        [children removeObjectsInRange:NSMakeRange(index,len)];
    }
}


- (NSString *)formatForDescription:(NSString *)spaces
{
    NSString *children_str = nil;
    if ([children count]) {
        children_str = @"\n";
        NSString *more_spaces = [NSString stringWithFormat:@"\t%@", spaces];
        for (id child in children) {
            if ([child isKindOfClass:[PVSyntaxNode class]]) {
                children_str = [NSString stringWithFormat:@"%@%@\n",
                                children_str,
                                [((PVSyntaxNode *)child) formatForDescription:more_spaces]];
            } else {
                children_str = [NSString stringWithFormat:@"%@%@%@\n",
                                children_str,
                                more_spaces,
                                [child description]];
            }
        }
    } else {
        children_str = @"(none)";
    }
    if (name) {
        if (error) {
            return [NSString stringWithFormat:@"%@<%s(%@: %@)@0x%X (from %ld to %ld): children:%@>",
                    spaces, class_getName([self class]), name, error,
                    (unsigned)(void*)self, (unsigned long)range.location, (unsigned long)(range.location+range.length), children_str];
            
        } else {
            return [NSString stringWithFormat:@"%@<%s(%@)@0x%X (from %ld to %ld): children:%@>",
                    spaces, class_getName([self class]), name,
                    (unsigned)(void*)self, (unsigned long)range.location, (unsigned long)(range.location+range.length), children_str];
        }
    } else {
        if (error) {
            return [NSString stringWithFormat:@"%@<%s(: %@)@0x%X (from %ld to %ld): children:%@>",
                    spaces, class_getName([self class]), error,
                    (unsigned)(void*)self, (unsigned long)range.location, (unsigned long)(range.location+range.length), children_str];
            
        } else {
            return [NSString stringWithFormat:@"%@<%s@0x%X (from %ld to %ld): children:%@>",
                    spaces, class_getName([self class]),
                    (unsigned)(void*)self, (unsigned long)range.location, (unsigned long)(range.location+range.length), children_str];
        }
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
