//
//  PVCGSequence.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVSequence.h"

@implementation PVSequence

- (id)initWithOrder:(NSArray *)_order
{
    self = [super init];
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
    return [[PVSequence alloc] initWithOrder:order];
}

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger uid = ctx.position;
    for (PVRule *rule in order) {
        if(![ctx evaluateRule:rule parent:parent]) {
            [ctx memoize:uid withBool:NO];
            return NO;
        }
    }
    return YES;
}


#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithOrder:[coder decodeObjectForKey:@"order"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:order forKey:@"order"];
}


@end
