//
//  PVParserContext.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PVSyntaxNode, PVRule;
@interface PVParserContext : NSObject
{
    NSInteger position;
    NSString *input;
    NSMutableDictionary *memos;
}

@property (readwrite) NSInteger position;
@property (readonly) NSString *input;
@property (readonly) NSMutableDictionary *memos;

-(id)initWithInput:(NSString *)_in memoTable:(NSArray *)mtable;
-(BOOL)evaluateRule:(PVRule *)rule parent:(PVSyntaxNode *)node;
-(void)memoize:(NSUInteger)pos with:(NSObject *)obj;
-(void)memoize:(NSUInteger)pos withBool:(BOOL)b;

@end
