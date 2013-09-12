//
//  PVCGOrderedChoice.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVOrderedChoice.h"

@implementation PVOrderedChoice

@synthesize choices;

- (id)initWithChoices:(NSArray *)_choices
{
    self = [super init];
    if (self) {
        choices = [_choices retain];
    }
    return self;
}

- (void)dealloc
{
    [choices release];
    [super dealloc];
}

+ (PVOrderedChoice *) :(PVRule *)first, ...
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
    return [[PVOrderedChoice alloc] initWithChoices:order];
}


- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger pos = ctx.position;
    NSUInteger len = 0;
    if (parent) {
        len = [parent.children count];
    }
    for (PVRule *rule in choices) {
        if (parent) {
            [parent removeChildrenAfter:len];
        }
        if ([ctx evaluateRule:rule parent:parent]) {
            return YES;
        }
        ctx.position = pos;
    }
    [ctx memoize:ctx.position withBool:NO];
    return NO;
}


#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithChoices:[coder decodeObjectForKey:@"choices"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:choices forKey:@"choices"];
}


@end
