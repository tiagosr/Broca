//
//  PVCGSequence.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVSequence.h"

@implementation PVSequence

- (id)initWithName:(NSString *)_name order:(NSArray *)_order
{
    self = [super initWithName:_name];
    if (self) {
        order = [_order retain];
    }
    
    return self;
}

- (void)dealloc
{
    [order release];
    [super dealloc];
}

+ (PVSequence *) :(PVRule *)first, ...
{
    NSMutableArray *order = [NSMutableArray array];
    va_list args;
    PVRule *obj;
    if(first) {
        [order addObject:first];
        va_start(args, first);
        while ((obj = va_arg(args, PVRule *))) {
            [order addObject:obj];
        }
    }
    return [[PVSequence alloc] initWithName:nil order:order];
}

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    PVSyntaxNode *old_parent = parent;
    if (name) {
        parent = [[PVSyntaxNode alloc] initWithName:name source:ctx.input range:NSMakeRange(ctx.position, 0)];
    }
    NSUInteger uid = ctx.position;
    for (PVRule *rule in order) {
        if(![ctx evaluateRule:rule parent:parent]) {
            [ctx memoize:uid withBool:NO];
            if (old_parent != parent) {
                [parent release];
                parent = nil;
            }
            return NO;
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
    self = [self initWithName:[coder decodeObjectForKey:@"name"] order:[coder decodeObjectForKey:@"order"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:order forKey:@"order"];
}


@end
