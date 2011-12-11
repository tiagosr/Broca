//
//  PVCGName.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVName.h"
#import "PVParserContextMemo.h"

@implementation PVName


@synthesize name, reference;

- (id)initWithName:(NSString *)_name ref:(PVRule *)ref
{
    self = [super init];
    if (self) {
        name = [_name copy];
        reference = [ref retain];
    }
    return self;
}

- (void) dealloc
{
    [name release];
    [reference release];
    [super dealloc];
}

+ (PVName *):(NSString *)_name :(PVRule *)ref
{
    return [[PVName alloc] initWithName:_name ref:ref];
}


- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger uid = ctx.position;
    PVSyntaxNode *node = [[PVSyntaxNode alloc] initWithName:name source:ctx.input range:NSMakeRange(ctx.position, 0)];
    if(![ctx evaluateRule:reference parent:node]) {
        [ctx memoize:uid withBool:NO];
        return NO;
    } 
    node.range = NSMakeRange(node.range.location, ctx.position - node.range.location);
    [ctx memoize:uid with:[PVParserContextMemo withNode:node at:node.range.location]];
    if (parent) [parent.children addObject:node];
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
