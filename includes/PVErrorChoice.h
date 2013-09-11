//
//  PVCGErrorChoice.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVOrderedChoice.h"

@interface PVErrorChoice : PVOrderedChoice
{
    NSString *error;
}

+ (PVErrorChoice *) error:(NSString *)error :(PVRule *)first, ...;

@end
