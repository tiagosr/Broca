//
//  PVRegex.h
//  Broca
//
//  Created by Tiago Rezende on 9/9/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVRegex : PVRule
{
    NSRegularExpression *regex;
}
@property (readwrite, retain) NSRegularExpression *regex;

+ (PVRegex *) :(NSString *)regexstring :(NSRegularExpressionOptions)options;
+ (PVRegex *) named:(NSString *)_name :(NSString *)regexstring :(NSRegularExpressionOptions)options;

- (id) initWithName:(NSString *)_name regexString:(NSString *)regexstring options:(NSRegularExpressionOptions)options;

@end
