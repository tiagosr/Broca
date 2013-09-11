//
//  PVCompiledGrammar.m
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVCompiledGrammar.h"

@implementation PVCompiledGrammar

- (id)initWithRuleSet:(PVRuleSet *)_ruleset
{
    self = [super init];
    if (self) {
        ruleset = [_ruleset retain];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self initWithRuleSet:[coder decodeObjectForKey:@"ruleset"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:ruleset forKey:@"ruleset"];
}

- (PVSyntaxNode *)parseString:(NSString *)str startingRule:(NSString *)rule
{
    PVParserContext *ctx = [[PVParserContext alloc] initWithInput:str
                                                        memoTable:[NSArray array]];
    PVSyntaxNode *root_node = [[PVSyntaxNode alloc] initWithName:rule
                                                          source:str
                                                           range:NSMakeRange(0, [str length])];
    [ctx evaluateRule:[ruleset ruleForKey:rule] parent:root_node];
    return root_node;
}




@end
