//
//  PVRuleSet.h
//  Broca
//
//  Created by Tiago Rezende on 9/10/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVRule.h"


@interface PVRuleSet : NSObject <NSCoding>
{
    NSMutableDictionary *rules;
}
@property (readonly) NSMutableDictionary *rules;

-(PVRule *)ruleForKey:(NSString *)key;
-(void)setRuleNamed:(NSString *)name :(PVRule *)rule;
-(PVRule *)ref:(NSString *)rule;

+(PVRuleSet *) ruleset;
@end
