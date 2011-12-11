//
//  PVCGErrorChoice.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVErrorChoice.h"

@implementation PVErrorChoice

- (id)initWithError:(NSString *)err choices:(NSArray *)_choices
{
    self = [super initWithChoices:_choices];
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

#pragma mark -
#pragma mark match method

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger pos = ctx.position;
    for (PVRule *rule in choices) {
        if ([ctx evaluateRule:rule parent:parent]) {
            return YES;
        }
        ctx.position = pos;
    }
    [ctx.memos setObject:[NSNull null] forKey:[NSNumber numberWithLong:ctx.position]];
    return NO;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithError:[coder decodeObjectForKey:@"error"] choices:[coder decodeObjectForKey:@"choices"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:choices forKey:@"choices"];
    [coder encodeObject:error forKey:@"error"];
}


@end
