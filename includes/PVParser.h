//
//  PVParser.h
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVCompiledGrammar.h"

@class PVSyntaxNode;
@class PVRule;
@interface PVParser : NSObject
{
    PVCompiledGrammar *g;
}
-(id)initWithGrammarString:(NSString *)grammarstring;
-(id)initWithEncodedGrammar:(NSCoder *)codedGrammar;
-(id)initWithRuleSet:(PVRuleSet *)ruleset;

-(void)encodeGrammar:(NSCoder *)coder;

- (PVSyntaxNode *) parseString:(NSString *)str
                      fromRule:(NSString *)rule;

@end
