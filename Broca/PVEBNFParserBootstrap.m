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
#import "PVNegativeLookAhead.h"
#import "PVOneOrMore.h"
#import "PVOptional.h"
#import "PVOrderedChoice.h"
#import "PVPositiveLookAhead.h"
#import "PVSequence.h"
#import "PVLiteral.h"
#import "PVZeroOrMore.h"
#import "PVForward.h"
#import "PVIgnore.h"

static PVCompiledGrammar *grammar = nil;
static PVRule * EBNF_ParseSourceElement(PVSyntaxNode *node, PVRule *parent);
static PVRule * EBNF_ParseAssignmentExpression(PVSyntaxNode *node, PVRule *parent);

@implementation PVEBNFParserBootstrap

// based on the langage.js ebnf parser 
+ (PVRule *)bootstrap
{
    PVCharacter *WhiteSpace = [PVCharacter charset:[NSCharacterSet whitespaceCharacterSet]];
    PVRule *LineTerminator = [PVCharacter charset:[NSCharacterSet newlineCharacterSet]];
    PVOrderedChoice *LineTerminatorSequence = [PVOrderedChoice :
                                                [PVLiteral :@"\n"],
                                                [PVLiteral :@"\r\n"],
                                                [PVLiteral :@"\u2028"],
                                                [PVLiteral :@"\u2029"],
                                                [PVLiteral :@"\r"],
                                                nil];
    PVSequence *SingleLineCommentChar = [PVSequence :[PVNegativeLookAhead :LineTerminator], [PVDot dot], nil];
    PVRule *SingleLineComment = [PVSequence named:@"SingleLineComment" :[PVLiteral :@"//"], [PVZeroOrMore :SingleLineCommentChar]];
    PVRule *MultiLineComment = [PVSequence named:@"MultiLineComment" :
                                [PVLiteral :@"/*"],
                                [PVZeroOrMore :[PVSequence :[PVNegativeLookAhead :[PVLiteral :@"*/"]],[PVDot dot],nil]],
                                [PVLiteral :@"*/"],
                                nil];
    
    PVRule *Comment = [PVOrderedChoice named:@"Comment" :SingleLineComment,MultiLineComment,nil];
    
    // ignored tokens
    PVRule *_ = [PVIgnore :[PVZeroOrMore :[PVOrderedChoice :WhiteSpace,
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
    PVCharacter *SingleEscapeCharacter = [PVCharacter inString:@"'\"\\bfnrtv"];
    PVOrderedChoice *EscapeCharacter = [PVOrderedChoice :
                                        SingleEscapeCharacter,
                                        DecimalDigit,
                                        [PVLiteral :@"x"],
                                        [PVLiteral :@"u"],
                                        nil];
    PVSequence *NonEscapeCharacter = [PVSequence :
                                      [PVNegativeLookAhead :LineTerminator],
                                      [PVNegativeLookAhead :EscapeCharacter],
                                      [PVDot dot],
                                      nil];
    PVOrderedChoice *CharacterEscapeSequence = [PVOrderedChoice :
                                                SingleEscapeCharacter,
                                                NonEscapeCharacter,
                                                nil];
    PVOrderedChoice *EscapeSequence = [PVOrderedChoice :
                                       CharacterEscapeSequence,
                                       [PVSequence :nil],
                                       HexEscapeSequence,
                                       UnicodeEscapeSequence,
                                       nil];
    PVRule *SingleStringCharacter = [PVOrderedChoice :
                                     [PVNegativeLookAhead :[PVOrderedChoice :
                                                            [PVLiteral :@"'"],
                                                            [PVLiteral :@"\\"],
                                                            LineTerminator,
                                                            nil]],
                                     [PVSequence :[PVLiteral :@"\\"], EscapeSequence, nil],
                                     nil];
    PVRule *DoubleStringCharacter = [PVOrderedChoice :
                                     [PVNegativeLookAhead :[PVOrderedChoice :
                                                            [PVLiteral :@"\""],
                                                            [PVLiteral :@"\\"],
                                                            LineTerminator,
                                                            nil]],
                                     [PVSequence :[PVLiteral :@"\\"], EscapeSequence, nil],
                                     nil];
    PVRule *StringLiteral = [PVOrderedChoice named:@"StringLiteral"  :
                              [PVSequence :
                               [PVLiteral :@"\""],
                               [PVZeroOrMore :DoubleStringCharacter],
                               [PVLiteral :@"\""],
                               nil],
                              [PVSequence :
                               [PVLiteral :@"'"],
                               [PVZeroOrMore :SingleStringCharacter],
                               [PVLiteral :@"'"],
                               nil],
                              nil];
    PVLiteral *ZWNJ = [PVLiteral :@"\u200C"];
    PVLiteral *ZWJ = [PVLiteral :@"\u200D"];
    PVRule *IdentifierStart = [PVOrderedChoice :UnicodeLetter,
                               [PVLiteral :@"$"],
                               [PVLiteral :@"_"],
                               [PVSequence :[PVLiteral :@"\\"], UnicodeEscapeSequence, nil],
                               nil];
    PVRule *IdentifierPart = [PVOrderedChoice :IdentifierStart,
                              UnicodeCombiningMark,
                              UnicodeDigit,
                              UnicodeConnectorPunctuation,
                              ZWNJ,
                              ZWJ,
                              nil];
    PVRule *Identifier = [PVSequence :IdentifierStart, [PVZeroOrMore :IdentifierPart], nil];
    
    PVForward *ErrorChoiceExpression = [PVForward forward];
    
    PVRule *ParentheticalExpression = [PVSequence named:@"ParentheticalExpression"
                                                       :[PVLiteral :@"("], _,
                                                        ErrorChoiceExpression, _,
                                                        [PVLiteral :@")"],nil];
    PVRule *DotExpression = [PVLiteral named:@"DotExpression" :@"."];
    PVRule *PrimaryExpression =  [PVOrderedChoice named:@"PrimaryExpression" :
                                  [PVSequence :Identifier,
                                   [PVNegativeLookAhead :[PVSequence :_,
                                                          [PVCharacter inString:@"=<"],
                                                          nil]],
                                   nil],
                                  StringLiteral,
                                  DotExpression,
                                  CharacterClass,
                                  ParentheticalExpression,
                                  nil];
    PVRule *SuffixedExpression = [PVSequence named:@"SuffixedExpression" :
                                   PrimaryExpression,
                                   [PVOptional :[PVSequence :
                                                 _,
                                                 [PVCharacter inString:@"?*+"],
                                                 nil]],
                                   nil];
    PVRule *PrefixedExpression =  [PVSequence named:@"PrefixedExpression" :
                                   [PVOptional :[PVSequence :
                                                 [PVCharacter inString:@"&!"],
                                                 _,
                                                 nil]],
                                   SuffixedExpression,
                                   nil];
    PVRule *SequenceExpression =  [PVOneOrMore named:@"SequenceExpression" :[PVSequence :
                                                 PrefixedExpression,
                                                 _,
                                                 nil]];
    PVRule *OrderedChoiceExpression =  [PVSequence named:@"OrderedChoiceExpression" :SequenceExpression,
                                        [PVZeroOrMore :[PVSequence :
                                                        _,
                                                        [PVLiteral :@"/"],
                                                        _,
                                                        SequenceExpression,
                                                        nil]], nil];
    PVRule *fErrorChoiceExpression =  [PVSequence named:@"ErrorChoiceExpression" :
                                       OrderedChoiceExpression,
                                       [PVOptional :[PVSequence :
                                                     _,
                                                     [PVLiteral :@"%"],
                                                     _,
                                                     OrderedChoiceExpression,
                                                     nil]],
                                       nil];
    ErrorChoiceExpression.forwarded = fErrorChoiceExpression;
    PVRule *AngleBracketCharacter = [PVOrderedChoice :
                                     [PVSequence :
                                      [PVNegativeLookAhead :[PVOrderedChoice :
                                                             [PVCharacter inString:@"<>\\"],
                                                             LineTerminator,
                                                             nil]],
                                      [PVDot dot],
                                      nil],
                                     [PVSequence :
                                      [PVLiteral :@"\\"],
                                      EscapeSequence,
                                      nil],
                                     LineContinuation,
                                     nil];
    PVRule *ErrorMessage = [PVSequence named:@"ErrorMessage" :
                             [PVLiteral :@"<"],
                             AngleBracketCharacter,
                             [PVLiteral :@">"],
                             nil];
    PVRule *AssignmentExpression = [PVSequence named:@"AssignmentExpression" :
                                     Identifier, _,
                                     [PVLiteral :@"="], _,
                                     ErrorChoiceExpression,
                                     nil];
    PVRule *ErrorAssignmentExpression = [PVSequence named:@"ErrorAssignmentExpression" :
                                                     Identifier, _,
                                                     ErrorMessage, _,
                                                     [PVLiteral :@"="], _,
                                                     ErrorChoiceExpression,
                                                     nil];
    PVRule *SourceElement = [PVOrderedChoice named:@"SourceElement" :
                             AssignmentExpression,
                             ErrorAssignmentExpression, nil];
    // start of the program
    PVRule *start = [PVSequence named: @"start" :_,[PVZeroOrMore :[PVSequence :SourceElement, _, nil]], nil];
    return start;
}

- (id)init
{
    self = [super init];
    if (self) {
        if (!root) {
            root = [PVEBNFParserBootstrap bootstrap];            
        }
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
    if (!grammar) {
        grammar = [[PVEBNFParserBootstrap alloc] init];
    }
    PVSyntaxNode *grammar_node_start = [grammar parseString:str];
    PVRule *result = nil;
    if ([grammar_node_start.given_name isEqualToString:@"start"]) {
        NSArray *nodes = [[grammar_node_start childNodeAt:0] childNodeAt:0].children;
        NSMutableArray *node_results = [[NSMutableArray alloc] init];
        for (PVSyntaxNode *node in nodes) {
            [node_results addObject:EBNF_ParseSourceElement(node, nil)];
        }
        result = [node_results objectAtIndex:0];
    }
    return result;
}

@end

PVRule *EBNF_ParseSourceElement(PVSyntaxNode *node, PVRule *parent) {
    
    return nil;
}

PVRule *EBNF_ParseAssignmentExpression(PVSyntaxNode *node, PVRule *parent) {
    return nil;
}
