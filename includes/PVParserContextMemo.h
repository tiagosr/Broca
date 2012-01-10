//
//  PVParserContextMemo.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVSyntaxNode;

@interface PVParserContextMemo : NSObject
{
    NSUInteger position;
    PVSyntaxNode *node;
}
@property (readwrite) NSUInteger position;
@property (readwrite, retain) PVSyntaxNode *node;

- (id)initWithNode:(PVSyntaxNode *)_node at:(NSUInteger)pos;
+ (PVParserContextMemo *)withNode:(PVSyntaxNode *)_node at:(NSUInteger)pos;
@end
