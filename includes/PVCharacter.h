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

- (id) initWithName:(NSString *)_name charset:(NSCharacterSet *)chars;

+ (PVCharacter *) charset:(NSCharacterSet *)chars;
+ (PVCharacter *) inString:(NSString *)str;
+ (PVCharacter *) named:(NSString *)_name charset:(NSCharacterSet *)chars;
+ (PVCharacter *) named:(NSString *)_name inString:(NSString *)str;

@end
