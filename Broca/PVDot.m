//
//  PVCGDot.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVDot.h"

@implementation PVDot

-(BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    if (ctx.position < [ctx.input length]) {
        [ctx pushRange:NSMakeRange(ctx.position, 1) toParent:parent named:name];
        ctx.position ++;
        return YES;
    }
    [ctx memoize:ctx.position withBool:NO];
    return NO;
}

+ (PVDot *)dot
{
    return [[PVDot alloc] initWithName:nil];
}

+ (PVDot *)named:(NSString *)_name
{
    return [[PVDot alloc] initWithName:_name];
}

@end
