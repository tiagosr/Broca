//
//  PVIgnore.m
//  Broca
//
//  Created by Tiago Rezende on 12/11/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVIgnore.h"

@implementation PVIgnore

-(id)initWithRef:(PVRule *)ref
{
    self = [self init];
    if (self) {
        reference = [ref retain];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithRef:[coder decodeObject]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:reference];
}

+(PVIgnore *):(PVRule *)rule
{
    return [[PVIgnore alloc] initWithRef:rule];
}

-(BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    BOOL result = [reference match:ctx parent:NULL]; // no parent, no writing
    return result;  // but keeping the error tracking
}

@end
