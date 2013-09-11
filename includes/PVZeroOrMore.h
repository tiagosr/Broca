//
//  PVCGZeroOrMore.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVZeroOrMore : PVRule
{
    PVRule *reference;
}
- (id) initWithRef:(PVRule *)ref;
+ (PVZeroOrMore *) :(PVRule *)ref;

@end
