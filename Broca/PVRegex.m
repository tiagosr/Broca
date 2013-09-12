//
//  PVRegex.m
//  Broca
//
//  Created by Tiago Rezende on 9/9/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import "PVRegex.h"

@implementation PVRegex

@synthesize regex;

+(PVRegex *):(NSString *)regexstring :(NSRegularExpressionOptions)options
{
    return [[PVRegex alloc] initWithRegexString:regexstring options:options];
}


-(id)initWithRegexString:(NSString *)regexstring options:(NSRegularExpressionOptions)options
{
    self = [self init];
    if (self) {
        self.regex = [NSRegularExpression regularExpressionWithPattern:regexstring
                                                               options:options error:NULL];
    }
    return self;
}

-(BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    NSRange range = NSMakeRange(ctx.position, [ctx.input length]-ctx.position);
    NSTextCheckingResult * match = [self.regex firstMatchInString:ctx.input options:NSMatchingAnchored range:range];
    if (match) {
        [ctx pushRange:[match range] toParent:parent];
        ctx.position += [match range].length;
        return YES;
    }
    [ctx pushError:@"match unsuccessful" forRange:NSMakeRange(ctx.position, 0) toParent:parent];
    return NO;
}

-(id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithRegexString:[coder decodeObjectForKey:@"pattern"]
                             options:[coder decodeIntForKey:@"options"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:regex.pattern forKey:@"pattern"];
    [coder encodeInt:regex.options forKey:@"options"];
}
@end
