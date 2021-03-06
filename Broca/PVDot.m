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
        [ctx pushRange:NSMakeRange(ctx.position, 1) toParent:parent];
        ctx.position ++;
        return YES;
    }
    [ctx pushError:@"end of input unexpected" forRange:NSMakeRange(ctx.position, 0) toParent:parent];
    [ctx memoize:ctx.position withBool:NO];
    return NO;
}

+ (PVDot *)dot
{
    return [[PVDot alloc] init];
}

@end
