//
//  PVCGOptional.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVOptional : PVRule
{
    PVRule *reference;
}
- (id) initWithRef:(PVRule *)ref;

+ (PVOptional *) :(PVRule *)ref;

@end
