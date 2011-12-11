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
        if (parent) {
            [parent.children addObject:[ctx.input substringWithRange:NSMakeRange(ctx.position, 1)]];
        }
        ctx.position ++;
        return YES;
    }
    [ctx memoize:ctx.position withBool:NO];
    return NO;
}

+ (PVDot *)dot
{
    return [[PVDot alloc] init];
}

@end
