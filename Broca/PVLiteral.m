//
//  PVCGStringLiteral.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVLiteral.h"

@implementation PVLiteral

- (id)initWithLiteral:(NSString *)lit
{
    self = [super init];
    if (self) {
        literal = [lit copy];
    }
    
    return self;
}
- (void)dealloc
{
    [literal release];
    [super dealloc];
}

+ (PVLiteral *):(NSString *)literal
{
    return [[PVLiteral alloc] initWithLiteral:literal];
}

- (BOOL) match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    if ([[ctx.input substringWithRange:NSMakeRange(ctx.position, [literal length])] isEqualToString:literal]) {
        if (parent) {
            [parent.children addObject:literal];
        }
        ctx.position += [literal length];
        return YES;
    }
    [ctx memoize:ctx.position withBool:NO];
    return NO;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithLiteral:[coder decodeObject]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:literal];
}

@end