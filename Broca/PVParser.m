//
//  PVParser.m
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVParser.h"
#import "PVRule.h"
#import "PVSyntaxNode.h"
#import "PVEBNFParserBootstrap.h"

@implementation PVParser

- (id)initWithRuleSet:(PVRuleSet *)ruleset
{
    self = [self init];
    if (self) {
        g = [[PVCompiledGrammar alloc] initWithRuleSet:ruleset];
    }
    return self;
}

- (id)initWithEncodedGrammar:(NSCoder *)codedGrammar
{
    self = [self init];
    if (self) {
        g = [[PVCompiledGrammar alloc] initWithCoder:codedGrammar];
    }
    return self;
}

-(void)encodeGrammar:(NSCoder *)coder
{
    [g encodeWithCoder:coder];
}

-(id)initWithGrammarString:(NSString *)grammarstring
{
    PVRuleSet *ebnf = [PVEBNFParserBootstrap compileEBNFString:grammarstring];
    self = [self initWithRuleSet:ebnf];
    return self;
}

- (PVSyntaxNode *)parseString:(NSString *)str fromRule:(NSString *)rule
{
    return [g parseString:str startingRule:rule];
}

@end
