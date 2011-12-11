//
//  PVCGErrorName.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVErrorName.h"
#import "PVParserContextMemo.h"

@implementation PVErrorName

-(id)initWithName:(NSString *)_name error:(NSString *)err ref:(PVRule *)ref
{
    self = [super initWithName:_name ref:ref];
    if (self) {
        error = [err copy];
    }
    return self;
}

- (void)dealloc
{
    [error release];
    [super dealloc];
}

+ (PVErrorName *)name:(NSString *)name error:(NSString *)err :(PVRule *)ref
{
    return [[PVErrorName alloc] initWithName:name error:err ref:ref];
}

#pragma mark -
#pragma mark match method

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger uid = ctx.position;
    PVSyntaxNode *node = [[PVSyntaxNode alloc] initWithName:name source:ctx.input range:NSMakeRange(ctx.position, 0) error:error];
    if(![ctx evaluateRule:reference parent:node]) {
        [ctx memoize:ctx.position withBool:NO];
        return NO;
    } else {
        node.range = NSMakeRange(node.range.location, ctx.position - node.range.location);
        [ctx.memos setObject:[PVParserContextMemo withNode:node at:node.range.location] forKey:[NSNumber numberWithLong:uid]];
        if (parent) [parent.children addObject:node];
    }
    return YES;
}


#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithName:[coder decodeObjectForKey:@"name"] error:[coder decodeObjectForKey:@"error"] ref:[coder decodeObjectForKey:@"ref"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:reference forKey:@"ref"];
    [coder encodeObject:error forKey:@"error"];
}


@end
