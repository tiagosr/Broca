//
//  PVCGSequence.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVSequence : PVRule
{
    NSArray *order;
}

- (id) initWithOrder:(NSArray *)_order;
+ (PVSequence *) :(PVRule *)first, ...;
+ (PVSequence *) named:(NSString *)_name :(PVRule *)first, ...;

@end
