//
//  PVIgnore.h
//  Broca
//
//  Created by Tiago Rezende on 12/11/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVIgnore : PVRule
{
    PVRule *reference;
}
+(PVIgnore *):(PVRule *)ref;

@end
