//
//  PVCGNegativeLookAhead.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVNegativeLookAhead.h"

@implementation PVNegativeLookAhead

- (id)initWithName:(NSString *)_name ref:(PVRule *)ref
{
    self = [super initWithName:_name];
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
    return [[PVNegativeLookAhead alloc] initWithName:nil ref:ref];
}

+ (PVNegativeLookAhead *)named:(NSString *)_name :(PVRule *)ref
{
    return [[PVNegativeLookAhead alloc] initWithName:_name ref:ref];
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
    self = [self initWithName:[coder decodeObjectForKey:@"name"] ref:[coder decodeObjectForKey:@"ref"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:reference forKey:@"ref"];
}
@end
