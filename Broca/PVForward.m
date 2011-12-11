//
//  PVForward.m
//  Broca
//
//  Created by Tiago Rezende on 12/10/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVForward.h"

@implementation PVForward

@synthesize forwarded;

+(PVForward *)forward
{
    return [[PVForward alloc] init];
}

#pragma mark -
#pragma mark match method

-(BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    return [forwarded match:ctx parent:parent];
}


#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        forwarded = [coder decodeObject];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:forwarded];
}
@end
