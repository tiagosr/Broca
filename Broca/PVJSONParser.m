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

static PVJSONParser *jsonparser = nil;

@implementation PVJSONParser

+(PVRuleSet *)bootstrap
{
    PVRuleSet *ruleset = [PVRuleSet ruleset];
    PVIgnore *_ = [PVIgnore :[PVZeroOrMore :[PVCharacter inString:@" \t\n\r"]]];
    [ruleset setRuleNamed:@"string" :[PVRegex :@"\"([^\"\\\\]*|\\\\[\"\\\\bfnrt/]|\\\\u[0-9a-f]{4}))*\"" :0]];
    [ruleset setRuleNamed:@"symbol" :[PVRegex :@"[a-zA-Z_$][a-zA-Z_$0-9]*" :0]];
    [ruleset setRuleNamed:@"keyword" :[PVOrderedChoice :[PVLiteral :@"true"], [PVLiteral :@"false"], [PVLiteral :@"null"], nil]];
    [ruleset setRuleNamed:@"number" :[PVRegex :@"-?(?=[1-9]|0(?!\\d))\\d+(\\.\\d+)?([eE][+-]?\\d+)?" :0]];
    PVIgnore *separator_comma = [PVIgnore :[PVLiteral :@","]];
    PVOrderedChoice *value = [PVOrderedChoice :
                              [ruleset ref:@"object"],
                              [ruleset ref:@"array"],
                              [ruleset ref:@"string"],
                              [ruleset ref:@"keyword"],
                              [ruleset ref:@"number"],
                              nil];
    PVSequence *value_comma = [PVSequence :value, _, separator_comma, nil];
    PVSequence *key_value = [PVSequence :_, [PVOrderedChoice :[ruleset ref:@"symbol"], [ruleset ref:@"string"], nil], _,
                             [PVIgnore :[PVLiteral :@":"]], _, value, _, nil];
    PVSequence *key_value_comma = [PVSequence :key_value, _, separator_comma, _, nil];

    [ruleset setRuleNamed:@"array" :[PVSequence :
                                     [PVLiteral :@"["], _,
                                     [PVZeroOrMore :value_comma],
                                     [PVOptional :value],
                                     [PVLiteral :@"]"],
                                     nil]];
    [ruleset setRuleNamed:@"object" :[PVSequence :_,
                                      [PVLiteral :@"{"],
                                      [PVZeroOrMore :key_value_comma],
                                      [PVOptional :key_value],
                                      [PVLiteral :@"}"], _, nil]];
    return ruleset;
}

+(PVSyntaxNode *)compileJSONString:(NSString *)str
{
    if (!jsonparser) {
        jsonparser = [[PVJSONParser alloc] initWithRuleSet:[PVJSONParser bootstrap]];
    }
    return [jsonparser parseString:str startingRule:@"object"];
}

@end
