//
//  PVCGNegativeLookAhead.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVNegativeLookAhead : PVRule
{
    PVRule *reference;
}
-(id)initWithRef:(PVRule *)ref;
+(PVNegativeLookAhead *):(PVRule *)ref;


@end
