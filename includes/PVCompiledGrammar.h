//
//  PVCompiledGrammar.h
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVSyntaxNode.h"
#import "PVParserContext.h"
#import "PVRuleSet.h"

@interface PVCompiledGrammar : NSObject <NSCoding> {
    PVRuleSet *ruleset;
}
- (id)initWithRuleSet:(PVRuleSet *)_ruleset;

- (PVSyntaxNode *)parseString:(NSString *)str startingRule:(NSString *)rule;


@end
