//
//  PVCGOrderedChoice.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import "PVRule.h"

@interface PVOrderedChoice : PVRule
{
    NSArray *choices;
}

@property (readonly) NSArray *choices;

- (id) initWithChoices:(NSArray *)choices;

+ (PVOrderedChoice *) :(PVRule *)first, ...;

@end
