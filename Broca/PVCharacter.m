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

- (id)initWithCharset:(NSCharacterSet *)chars
{
    self = [super init];
    if (self) {
        self->charset = [chars copy];
    }
    
    return self;
}

+ (PVCharacter *)charset:(NSCharacterSet *)chars
{
    return [[PVCharacter alloc] initWithCharset:chars];
}

+ (PVCharacter *)inString:(NSString *)str
{
    return [[PVCharacter alloc] initWithCharset:[NSCharacterSet characterSetWithCharactersInString:str]];
}

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    unichar character = [ctx.input characterAtIndex:ctx.position];
    if ([charset characterIsMember:character]) {
        if (parent)
            [parent.children addObject:[NSString stringWithCharacters:&character length:1]];
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
    self = [self initWithCharset:[coder decodeObjectForKey:@"charset"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:charset forKey:@"charset"];
}

@end
