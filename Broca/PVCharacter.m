//
//  PVCGCharacter.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVCharacter.h"

@implementation PVCharacter

@synthesize charset;

- (id)initWithName:(NSString *)_name charset:(NSCharacterSet *)chars
{
    self = [super initWithName:_name];
    if (self) {
        self->charset = [chars copy];
    }
    
    return self;
}

+ (PVCharacter *)charset:(NSCharacterSet *)chars
{
    return [[PVCharacter alloc] initWithName:nil charset:chars];
}

+ (PVCharacter *)inString:(NSString *)str
{
    return [[PVCharacter alloc] initWithName:nil charset:[NSCharacterSet characterSetWithCharactersInString:str]];
}

+ (PVCharacter *)named:(NSString *)_name charset:(NSCharacterSet *)chars
{
    return [[PVCharacter alloc] initWithName:_name charset:chars];
}

+ (PVCharacter *)named:(NSString *)_name inString:(NSString *)str
{
    return [[PVCharacter alloc] initWithName:_name charset:[NSCharacterSet characterSetWithCharactersInString:str]];
}

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    unichar character = [ctx.input characterAtIndex:ctx.position];
    if ([charset characterIsMember:character]) {
        [ctx pushRange:NSMakeRange(ctx.position, 1) toParent:parent named:name];
        ctx.position++;
        return YES;
    }
    [ctx memoize:ctx.position withBool:NO];
    return NO;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    charset = [coder decodeObjectForKey:@"charset"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:charset forKey:@"charset"];
}

@end
