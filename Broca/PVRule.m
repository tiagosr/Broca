//
//  PVCGObject.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@implementation PVRule

@synthesize name;

-(BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    return NO;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
}

@end
