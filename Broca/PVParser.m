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

- (id)initWithParserTree:(PVRule *)root
{
    self = [self init];
    if (self) {
        g = [[PVCompiledGrammar alloc] initWithParserTree:root];
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
    PVRule *ebnf = [PVEBNFParserBootstrap compileEBNFString:grammarstring];    
    self = [self initWithParserTree:ebnf];
    return self;
}

- (PVSyntaxNode *)parseString:(NSString *)str
{
    return [g parseString:str];
}

@end
