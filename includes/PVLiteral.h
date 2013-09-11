//
//  PVCGStringLiteral.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVLiteral : PVRule
{
    NSString *literal;
}
- (id) initWithName:(NSString *)_name literal:(NSString *)lit;
+ (PVLiteral *) :(NSString *)literal;
+ (PVLiteral *) named:(NSString *)_name :(NSString *)literal;
@end
