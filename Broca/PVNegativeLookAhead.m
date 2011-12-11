//
//  PVCGNegativeLookAhead.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVNegativeLookAhead.h"

@implementation PVNegativeLookAhead

- (id)initWithRef:(PVRule *)ref
{
    self = [super init];
    if (self) {
        reference = [ref retain];
    }
    
    return self;
}

- (void)dealloc
{
    [reference release];
    [super dealloc];
}

+ (PVNegativeLookAhead *):(PVRule *)ref
{
    return [[PVNegativeLookAhead alloc] initWithRef:ref];
}

#pragma mark -
#pragma mark match method

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger pos = ctx.position;
    BOOL result = ![ctx evaluateRule:reference parent:nil];
    ctx.position = pos;
    
    [ctx memoize:pos withBool:result];
    return result;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithRef:[coder decodeObject]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:reference];
}
@end
