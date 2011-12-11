//
//  PVParserContext.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVParserContext.h"
#import "PVSyntaxNode.h"
#import "PVRule.h"
#import "PVParserContextMemo.h"

@implementation PVParserContext

@synthesize position, input, memos;

- (id)initWithInput:(NSString *)_in memoTable:(NSArray *)mtable
{
    self = [super init];
    if (self) {
        position = 0;
        input = [_in retain];
        memos = [NSMutableDictionary dictionaryWithCapacity:[mtable count]];
    }
    return self;
}

- (void) dealloc
{
    [input release];
    [memos release];
    [super dealloc];
}

- (BOOL)evaluateRule:(PVRule *)rule parent:(PVSyntaxNode *)parent
{
    NSObject *node = [memos objectForKey:[NSNumber numberWithLong:position]];
    if (!node) {
        return [rule match:self parent:parent];
    } else if ([node isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)node boolValue];
    } else if ([node isKindOfClass:[PVParserContextMemo class]]) {
        [parent.children addObject:[(PVParserContextMemo *)node node]];
        position = [(PVParserContextMemo *)node position];
        return YES;
    }
    return NO;
}

- (void)memoize:(NSUInteger)pos with:(NSObject *)obj
{
    [memos setObject:obj forKey:[NSNumber numberWithLong:pos]];
}

- (void)memoize:(NSUInteger)pos withBool:(BOOL)b
{
    [memos setObject:[NSNumber numberWithBool:b] forKey:[NSNumber numberWithLong:pos]];
}

@end
