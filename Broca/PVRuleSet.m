//
//  PVRuleSet.m
//  Broca
//
//  Created by Tiago Rezende on 9/10/13.
//  Copyright (c) 2013 Pixel of View. All rights reserved.
//

#import "PVRuleSet.h"

#pragma mark PVRuleReference interface

@interface PVRuleReference : PVRule
{
    PVRuleSet *ruleset;
    NSString *ref;
}
-(id)initWithRuleset:(PVRuleSet *)_ruleset referenceTo:(NSString *)_rule;
@end

#pragma mark -
#pragma mark PVRuleReference implementation

@implementation PVRuleReference

-(id)initWithRuleset:(PVRuleSet *)_ruleset referenceTo:(NSString *)_rule
{
    self = [super init];
    if (self) {
        ruleset = _ruleset;
        ref = [_rule copy];
    }
    return self;
}

-(void) dealloc
{
    [ref release];
    [super dealloc];
}

-(BOOL)match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent
{
    PVSyntaxNode *new_parent = [[PVSyntaxNode alloc] initWithName:ref source:ctx.input range:NSMakeRange(ctx.position, 0)];
    BOOL result = [[ruleset ruleForKey:ref] match:ctx parent:new_parent];
    new_parent.range = NSMakeRange(new_parent.range.location, ctx.position - new_parent.range.location);
    [parent.children addObject:new_parent];
    return result;
}

-(id) initWithCoder:(NSCoder *)coder
{
    return [self initWithRuleset:[coder decodeObjectForKey:@"ruleset"] referenceTo:@"rule"];
}
-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:ruleset forKey:@"ruleset"];
    [coder encodeObject:ref forKey:@"rule"];
}

@end

#pragma mark -
#pragma mark PVRuleSet implementation

@implementation PVRuleSet

@synthesize rules;

-(id)init
{
    self = [super init];
    if (self) {
        rules = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)dealloc
{
    [rules release];
    [super dealloc];
}

-(PVRule *)ruleForKey:(NSString *)key
{
    return [rules objectForKey:key];
}

-(void)setRuleNamed:(NSString *)name :(PVRule *)rule
{
    [rules setObject:rule forKey:name];
}

-(PVRule *)ref:(NSString *)rule
{
    return [[PVRuleReference alloc] initWithRuleset:self referenceTo:rule];
}

+(PVRuleSet *)ruleset;
{
    return [[PVRuleSet alloc] init];
}

#pragma mark -
#pragma mark NSCoding methods

-(id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        rules = [coder decodeObjectForKey:@"rules"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:rules forKey:@"rules"];
}

@end
