//
//  PVCGOptional.m
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVOptional.h"

@implementation PVOptional

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

+ (PVOptional *):(PVRule *)ref
{
    return [[PVOptional alloc] initWithName:nil ref:ref];
}
+ (PVOptional *)named:(NSString *)_name :(PVRule *)ref
{
    return [[PVOptional alloc] initWithName:_name ref:ref];
}

#pragma mark -
#pragma mark match method

- (BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSUInteger pos = ctx.position;
    NSUInteger len = parent?[parent.children count]:0;
    if (![ctx evaluateRule:reference parent:parent]) {
        ctx.position = pos;
        if (parent) {
            NSUInteger remove_len = [parent.children count]-len;
            if (remove_len) {
                [parent.children removeObjectsInRange:NSMakeRange(len, remove_len)];
            }
        }
    }
    return YES;
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithName:[coder decodeObjectForKey:@"name"]
                          ref:[coder decodeObjectForKey:@"ref"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:reference forKey:@"ref"];
}
@end
