//
//  PVJSONParser.m
//  Broca
//
//  Created by Tiago Rezende on 9/9/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import "PVJSONParser.h"
#import "PVIgnore.h"
#import "PVCharacter.h"
#import "PVDot.h"
#import "PVErrorChoice.h"
#import "PVNegativeLookAhead.h"
#import "PVOneOrMore.h"
#import "PVOptional.h"
#import "PVOrderedChoice.h"
#import "PVPositiveLookAhead.h"
#import "PVSequence.h"
#import "PVLiteral.h"
#import "PVZeroOrMore.h"
#import "PVForward.h"
#import "PVRegex.h"
#import "PVParser.h"

static PVCompiledGrammar *jsonparser = nil;

@implementation PVJSONParser

+(PVRule *)bootstrap
{
    PVIgnore *_ = [PVIgnore :[PVZeroOrMore :[PVCharacter inString:@" \t\n\r"]]];
    PVForward *dict = [PVForward forward];
    PVForward *array = [PVForward forward];
    PVRule *string = [PVRegex named:@"string" :@"\"([^\"\\\\]*|\\\\[\"\\\\bfnrt/]|\\\\u[0-9a-f]{4}))*\"" :0];
    PVRule *symbol = [PVRegex named:@"symbol" :@"[a-zA-Z_$][a-zA-Z_$0-9]*" :0];
    PVRule *keyword = [PVOrderedChoice named:@"keyword" :[PVLiteral :@"true"], [PVLiteral :@"false"], [PVLiteral :@"null"], nil];
    PVRule *number = [PVRegex named:@"number" :@"-?(?=[1-9]|0(?!\\d))\\d+(\\.\\d+)?([eE][+-]?\\d+)?" :0];
    PVIgnore *separator_comma = [PVIgnore :[PVLiteral :@","]];
    PVOrderedChoice *value = [PVOrderedChoice :dict, array, string, keyword, number, nil];
    PVSequence *value_comma = [PVSequence :value, _, separator_comma, nil];
    PVSequence *key_value = [PVSequence :_, [PVOrderedChoice :symbol, string, nil], _,
                             [PVIgnore :[PVLiteral :@":"]], _, value, _, nil];
    PVSequence *key_value_comma = [PVSequence :key_value, _, separator_comma, _, nil];

    PVRule *farray = [PVSequence named:@"array" :
                      [PVLiteral :@"["], _,
                      [PVZeroOrMore :value_comma],
                      [PVOptional :value],
                      [PVLiteral :@"]"],
                      nil];
    PVRule *fdict = [PVSequence named:@"object" :_,
                                [PVLiteral :@"{"],
                                        [PVZeroOrMore :key_value_comma],
                                        [PVOptional :key_value],
                                        [PVLiteral :@"}"], _, nil];
    array.forwarded = farray;
    dict.forwarded = fdict;
    return dict;
}

+(PVSyntaxNode *)compileJSONString:(NSString *)str
{
    if (!jsonparser) {
        jsonparser = [[PVCompiledGrammar alloc] initWithParserTree:[PVJSONParser bootstrap]];
    }
    return [jsonparser parseString:str];
}

@end
