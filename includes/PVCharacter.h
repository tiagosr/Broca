//
//  PVCGCharacter.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVCharacter : PVRule
{
    NSCharacterSet *charset;
}

@property (readonly) NSCharacterSet *charset;

- (id)initWithCharset:(NSCharacterSet *)chars;

+ (PVCharacter *)charset:(NSCharacterSet *)chars;
+ (PVCharacter *)inString:(NSString *)str;

@end
