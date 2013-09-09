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
#import "PVErrorName.h"
#import "PVName.h"
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


@implementation PVJSONParser

+(PVRule *)bootstrap
{
    PVIgnore *_ = [PVIgnore :[PVZeroOrMore :[PVCharacter inString:@" \t\n\r"]]];
    PVForward *dict = [PVForward forward];
    PVForward *array = [PVForward forward];
    PVRegex *string = [PVRegex :@"\"([^\"\\\\]*|\\\\[\"\\\\bfnrt/]|\\\\u[0-9a-f]{4}))*\"" :0];
    PVRegex *symbol = [PVRegex :@"[a-zA-Z_$][a-zA-Z_$0-9]*" :0];
    PVOrderedChoice *keyword = [PVOrderedChoice :[PVLiteral :@"true"], [PVLiteral :@"false"], [PVLiteral :@"null"]];
    PVRegex *number = [PVRegex :@"-?(?=[1-9]|0(?!\\d))\\d+(\\.\\d+)?([eE][+-]?\\d+)?" :0];
    PVIgnore *separator_comma = [PVIgnore :[PVLiteral :@","]];
    PVOrderedChoice *value = [PVOrderedChoice :dict, array, string, keyword, number];
    PVSequence *value_comma = [PVSequence :value, _, separator_comma];
    PVSequence *key_value = [PVSequence :_, [PVOrderedChoice :symbol, string], _,
                             [PVLiteral :@":"], _, value, _];
    PVSequence *key_value_comma = [PVSequence :key_value, _, separator_comma, _];

    PVSequence *farray = [PVSequence :[PVLiteral :@"["], _, [PVZeroOrMore :value_comma], [PVOptional :value], [PVLiteral :@"]"]];
    PVSequence *fdict = [PVSequence :_, [PVLiteral :@"{"],
                                    [PVZeroOrMore :key_value_comma],
                                    [PVOptional :key_value],
                                    [PVLiteral :@"}"], _];

    array.forwarded = farray;
    dict.forwarded = fdict;
    PVName * start = [PVName :@"start" :dict];
    return start;
}

+(PVSyntaxNode *)compileJSONString:(NSString *)str
{
    
}

@end
