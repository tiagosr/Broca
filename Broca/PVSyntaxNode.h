//
//  PVSyntaxNode.h
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVSyntaxNodeTraverser.h"

@interface PVSyntaxNode : NSObject
{
    NSRange range;
    NSString *source;
    NSMutableArray *children;
    PVSyntaxNode *parent;
    NSString *given_name;
    NSString *error;
}
@property (readwrite) NSRange range;
@property (readonly) NSMutableArray *children;
@property (readonly) NSString *error;

- (id)initWithName:(NSString *)name source:(NSString *)str_source range:(NSRange)str_range;
- (id)initWithName:(NSString *)name source:(NSString *)str_source range:(NSRange)str_range error:(NSString *)err_text;
- (NSString *)innerText;
- (void)traverse:(id<PVSyntaxNodeTraverser>)walker;

@end
