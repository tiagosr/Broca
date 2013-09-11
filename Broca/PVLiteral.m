//
//  PVCGStringLiteral.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVLiteral.h"

@implementation PVLiteral

- (id)initWithName:(NSString *)_name literal:(NSString *)lit
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
    return [[PVLiteral alloc] initWithName:nil literal:literal];
}

+ (PVLiteral *)named:(NSString *)_name :(NSString *)literal
{
    return [[PVLiteral alloc] initWithName:_name literal:literal];
}

- (BOOL) match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    if ([[ctx.input substringWithRange:NSMakeRange(ctx.position, [literal length])] isEqualToString:literal]) {
        [ctx pushRange:NSMakeRange(ctx.position, [literal length]) toParent:parent named:name];
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
    self = [self initWithName:[coder decodeObjectForKey:@"name"] literal:[coder decodeObjectForKey:@"literal"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:literal forKey:@"literal"];
}

@end
