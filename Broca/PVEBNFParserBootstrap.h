//
//  PVEBNFParserBootstrap.h
//  Broca
//
//  Created by Tiago Rezende on 12/10/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVCompiledGrammar.h"

@interface PVEBNFParserBootstrap : PVCompiledGrammar

+(PVRule *)bootstrap;
+(PVRule *)compileEBNFString:(NSString *)str;

@end
