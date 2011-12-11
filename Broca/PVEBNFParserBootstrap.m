//
//  PVEBNFParserBootstrap.m
//  Broca
//
//  Created by Tiago Rezende on 12/10/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVEBNFParserBootstrap.h"
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


@implementation PVEBNFParserBootstrap

// based on the langage.js ebnf parser 
+ (PVRule *)bootstrap
{
    PVCharacter *WhiteSpace = [PVCharacter charset:[NSCharacterSet whitespaceCharacterSet]];
    PVName *LineTerminator = [PVName :@"LineTerminator" :[PVCharacter charset:[NSCharacterSet newlineCharacterSet]]];
    PVOrderedChoice *LineTerminatorSequence = [PVOrderedChoice :
                                                [PVLiteral :@"\n"],
                                                [PVLiteral :@"\r\n"],
                                                [PVLiteral :@"\u2028"],
                                                [PVLiteral :@"\u2029"],
                                                [PVLiteral :@"\r"],
                                                nil];
    PVSequence *SingleLineCommentChar = [PVSequence :[PVNegativeLookAhead :LineTerminator], [PVDot dot], nil];
    PVName *SingleLineComment = [PVName :@"SingleLineComment" :[PVSequence :[PVLiteral :@"//"], [PVZeroOrMore :SingleLineCommentChar]]];
    PVName *MultiLineComment = [PVName :@"MultiLineComment" :
                                        [PVSequence :
                                            [PVLiteral :@"/*"],
                                         [PVZeroOrMore :[PVSequence :[PVNegativeLookAhead :[PVLiteral :@"*/"]],[PVDot dot],nil]],
                                            [PVLiteral :@"*/"],
                                            nil]];
    
    PVName *Comment = [PVName :@"Comment" :[PVOrderedChoice :SingleLineComment,MultiLineComment,nil]];
    
    // ignored tokens
    PVName *_ = [PVName :@"_" :[PVZeroOrMore :[PVOrderedChoice :WhiteSpace,
                                                                        LineTerminator,
                                                                        Comment,
                                                                        nil]]];
    
    PVCharacter *UnicodeLetter = [PVCharacter charset:[NSCharacterSet letterCharacterSet]];
    PVCharacter *UnicodeCombiningMark = [PVCharacter charset:[NSCharacterSet nonBaseCharacterSet]];
    PVCharacter *UnicodeDigit = [PVCharacter charset:[NSCharacterSet decimalDigitCharacterSet]];
    PVCharacter *UnicodeConnectorPunctuation = [PVCharacter charset:[NSCharacterSet decomposableCharacterSet]];
    
    PVCharacter *DecimalDigit = [PVCharacter inString:@"0123456789"];
    PVCharacter *HexDigit = [PVCharacter inString:@"0123456789abcdefABCDEF"];
    PVOrderedChoice *DecimalIntegerLiteral = [PVOrderedChoice :[PVLiteral :@"0"], [PVSequence :[PVCharacter inString:@"123456789"],[PVOneOrMore :DecimalDigit],nil], nil];
    PVSequence *DecimalEscape = [PVSequence :DecimalIntegerLiteral, [PVNegativeLookAhead :DecimalDigit], nil];
    PVSequence *HexEscapeSequence = [PVSequence :[PVLiteral :@"x"],HexDigit,HexDigit, nil];
    PVSequence *UnicodeEscapeSequence = [PVSequence :[PVLiteral :@"u"],HexDigit,HexDigit,HexDigit,HexDigit,nil];
    
    PVSequence *LineContinuation = [PVSequence :[PVLiteral :@"\\"],LineTerminatorSequence];
    
    PVOrderedChoice *CharClassEscape = [PVOrderedChoice :DecimalEscape,[PVLiteral :@"b"],nil];
    PVOrderedChoice *CharClassAtom = [PVOrderedChoice :
                                            [PVLiteral :@"-"],
                                            [PVSequence :[PVNegativeLookAhead :[PVCharacter inString:@"\\]-"]],[PVDot dot],nil],
                                            [PVSequence :[PVLiteral :@"\\"], CharClassEscape, nil],
                                            nil];
    PVSequence *CharClassRange = [PVSequence :CharClassAtom, [PVLiteral :@"-"], CharClassAtom, nil];
    PVSequence *CharacterClass = [PVSequence :[PVLiteral :@"["],[PVZeroOrMore :[PVOrderedChoice :CharClassRange, CharClassAtom, nil]],[PVLiteral :@"]"],nil];
    
    PVName *AssignmentExpression = [PVName :@"AssignmentExpression" :
                                                    [PVSequence :nil]];
    PVName *ErrorAssignmentExpression = [PVName :@"ErrorAssignmentExpression" :
                                                    [PVSequence :nil]];
    
    
    PVName *SourceElement = [PVName :@"SourceElement" :
                                                    [PVOrderedChoice :
                                                                AssignmentExpression,
                                                                ErrorAssignmentExpression, nil]];
    // start of the program
    PVName *start = [PVName :@"start" :[PVSequence :_,[PVZeroOrMore :[PVSequence :SourceElement, _, nil]], nil]];
    return start;
}

- (id)init
{
    self = [super init];
    if (self) {
        root = [PVEBNFParserBootstrap bootstrap];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    return self;
}

- (id)initWithParserTree:(PVRule *)_root
{
    self = [self init];
    return self;
}

+ (PVRule *)compileEBNFString:(NSString *)str
{
    return nil;
}

@end
