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

- (id)initWithName:(NSString *)_name choices:(NSArray *)_choices
{
    self = [super initWithName:_name];
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
    return [[PVOrderedChoice alloc] initWithName:nil choices:order];
}

+ (PVOrderedChoice *)named:(NSString *)_name :(PVRule *)first, ...
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
    return [[PVOrderedChoice alloc] initWithName:_name choices:order];
}

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger pos = ctx.position;
    for (PVRule *rule in choices) {
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
    self = [self initWithName: [coder decodeObjectForKey:@"name"] choices:[coder decodeObjectForKey:@"choices"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:choices forKey:@"choices"];
}


@end
