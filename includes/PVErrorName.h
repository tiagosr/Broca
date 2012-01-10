//
//  PVCGErrorName.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVName.h"

@interface PVErrorName : PVName
{
    NSString *error;
}

-(id) initWithName:(NSString *)_name error:(NSString *)err ref:(PVRule *)ref;
+ (PVErrorName *)name:(NSString *)name error:(NSString *)err :(PVRule *)ref;

@end
