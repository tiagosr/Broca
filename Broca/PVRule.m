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

- (id)initWithName:(NSString *)_name
{
    self = [super init];
    if (self) {
        self.name = _name;
    }
    return self;
}

-(BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    return NO;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithName:[coder decodeObjectForKey:@"name"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
}

@end
