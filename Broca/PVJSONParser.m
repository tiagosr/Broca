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


@implementation PVJSONParser

+(PVRule *)bootstrap
{
    PVIgnore *_ = [PVIgnore :[PVZeroOrMore :[PVCharacter inString:@" \t\n\r"]]];
    PVForward *dict = [PVForward forward];
    
    
    PVSequence *key_value = [PVSequence :_,
                             [PVLiteral :@":"], _, _];
    PVSequence *key_value_comma = [PVSequence :key_value, _, [PVLiteral :@","], _];
    PVSequence *fdict = [PVSequence :_, [PVLiteral :@"{"],
                                    [PVZeroOrMore :key_value_comma],
                                    [PVOptional :key_value],
                                    [PVLiteral :@"}"], _];
    dict.forwarded = fdict;
    PVName * start = [PVName :@"start" :dict];
    return start;
}

+(PVSyntaxNode *)compileJSONString:(NSString *)str
{
    
}

@end
