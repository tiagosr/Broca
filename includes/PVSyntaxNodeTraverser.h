//
//  PVSyntaxNodeTraverser.h
//  Broca
//
//  Created by Tiago Rezende on 12/8/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVSyntaxNode;

@protocol PVSyntaxNodeTraverser <NSObject>

-(BOOL)enteredNode:(PVSyntaxNode *)node;
-(BOOL)exitedNode:(PVSyntaxNode *)node;

@end
