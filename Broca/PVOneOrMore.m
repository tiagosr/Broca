//
//  PVCGOneOrMore.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVOneOrMore.h"

@implementation PVOneOrMore

- (id)initWithName:(NSString *)_name ref:(PVRule *)ref
{
    self = [super initWithName:_name];
    if (self) {
        reference = [ref retain];
    }
    return self;
}

- (void)dealloc
{
    [reference release];
    [super dealloc];
}

+ (PVOneOrMore *):(PVRule *)ref
{
    return [PVOneOrMore named:nil :ref];
}
+ (PVOneOrMore *)named:(NSString *)_name :(PVRule *)ref
{
    return [[PVOneOrMore alloc] initWithName:_name ref:ref];
}

#pragma mark -
#pragma mark match method

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    PVSyntaxNode *old_parent = parent;
    if (name) {
        parent = [[PVSyntaxNode alloc] initWithName:name source:ctx.input range:NSMakeRange(ctx.position, 0)];
    }
    NSUInteger pos = ctx.position;
    NSUInteger len = parent?[parent.children count]:0;
    if (![ctx evaluateRule:reference parent:parent]) {
        ctx.position = pos;
        [ctx memoize:pos withBool:NO];
        if (parent) {
            NSUInteger remove_len = [parent.children count]-len;
            if (remove_len) {
                [parent.children removeObjectsInRange:NSMakeRange(len, remove_len)];
            }
        }
        if (old_parent != parent) {
            [parent release];
            parent = old_parent;
        }
        return NO;
    }
    pos = ctx.position;
    len = parent?[parent.children count]:0;
    while ([ctx evaluateRule:reference parent:parent]) {
        pos = ctx.position;
        len = parent?[parent.children count]:0;
    }
    ctx.position = pos;
    if (parent) {
        NSUInteger remove_len = [parent.children count]-len;
        if (remove_len) {
            [parent.children removeObjectsInRange:NSMakeRange(len, remove_len)];
        }
    }
    if (old_parent != parent) {
        [old_parent.children addObject:parent];
    }
    return YES;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithName:[coder decodeObjectForKey:@"name"] ref:[coder decodeObjectForKey:@"ref"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:reference forKey:@"ref"];
}
@end
