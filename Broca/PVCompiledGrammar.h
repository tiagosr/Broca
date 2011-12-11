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

@interface PVCompiledGrammar : NSObject <NSCoding> {
    PVRule *root;
}
- (id)initWithParserTree:(PVRule *)_root;

- (PVSyntaxNode *)parseString:(NSString *)str;


@end
