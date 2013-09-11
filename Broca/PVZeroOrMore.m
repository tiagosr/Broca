//
//  PVCGZeroOrMore.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVZeroOrMore.h"

@implementation PVZeroOrMore

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

+ (PVZeroOrMore *)named:(NSString *)_name :(PVRule *)ref
{
    return [[PVZeroOrMore alloc] initWithName:_name ref:ref];
}
+ (PVZeroOrMore *):(PVRule *)ref
{
    return [PVZeroOrMore named:nil :ref];
}

#pragma mark -
#pragma mark match method

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger pos = ctx.position;
    NSUInteger len = parent?[parent.children count]:0;
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
