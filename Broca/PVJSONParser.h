//
//  PVJSONParser.h
//  Broca
//
//  Created by Tiago Rezende on 9/9/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import "PVCompiledGrammar.h"


@interface PVJSONParser : PVCompiledGrammar

+(PVRule *)bootstrap;
+(PVSyntaxNode *)compileJSONString:(NSString *)str;

@end
