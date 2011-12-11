//
//  PVCGName.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVRule.h"

@interface PVName : PVRule
{
    NSString *name;
    PVRule *reference;
}
@property (readonly) NSString *name;
@property (readonly) PVRule *reference;

-(id)initWithName:(NSString *)_name ref:(PVRule *)ref;
+(PVName *):(NSString *)_name :(PVRule *)ref;

@end
