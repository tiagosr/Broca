//
//  PVCGOneOrMore.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVOneOrMore.h"

@implementation PVOneOrMore

- (id)initWithRef:(PVRule *)ref
{
    self = [super init];
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
    return [[PVOneOrMore alloc] initWithRef:ref];
}

#pragma mark -
#pragma mark match method

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger pos = ctx.position;
    NSUInteger len = parent?[parent.children count]:0;
    if (![ctx evaluateRule:reference parent:parent]) {
        ctx.position = pos;
        [ctx memoize:pos withBool:NO];
        if (parent) {
            [parent removeChildrenAfter:len];
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
        [parent removeChildrenAfter:len];
    }
    return YES;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithRef:[coder decodeObjectForKey:@"ref"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:reference forKey:@"ref"];
}
@end
