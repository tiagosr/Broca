//
//  PVForward.h
//  Broca
//
//  Created by Tiago Rezende on 12/10/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVForward : PVRule
{
    PVRule *forwarded;
}
@property (readwrite, retain) PVRule *forwarded;

+(PVForward *)forward;

@end
