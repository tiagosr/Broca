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
-(id)initWithParserTree:(PVRule *)root;

-(void)encodeGrammar:(NSCoder *)coder;

- (PVSyntaxNode *) parseString:(NSString *)str;
- (PVSyntaxNode *) parseString:(NSString *)str
              startingFromRule:(NSString *)rule;

@end
