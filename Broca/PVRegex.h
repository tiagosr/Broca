//
//  PVRegex.h
//  Broca
//
//  Created by Tiago Rezende on 9/9/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import <Broca/Broca.h>

@interface PVRegex : PVRule
{
    NSRegularExpression *regex;
}
@property (readwrite, retain) NSRegularExpression *regex;

+(PVRegex *) :(NSString *)regexstring :(NSRegularExpressionOptions)options;

-(id)initWithRegexString:(NSString *)regexstring options:(NSRegularExpressionOptions)options;

@end
