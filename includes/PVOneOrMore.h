//
//  PVCGOneOrMore.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVOneOrMore : PVRule
{
    PVRule *reference;
}

- (id) initWithName:(NSString *)_name ref:(PVRule *)ref;

+ (PVOneOrMore *) :(PVRule *)ref;
+ (PVOneOrMore *) named:(NSString *)_name :(PVRule *)ref;

@end
