//
//  PVCGObject.h
//  Broca
//
//  Created by Tiago Rezende on 12/9/11.
//  Copyright 2011 Pixel of View. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVSyntaxNode.h"
#import "PVParserContext.h"

@interface PVRule : NSObject <NSCoding>
{
}
@property (readwrite, copy) NSString *name;

- (BOOL) match:(PVParserContext *)ctx parent:(PVSyntaxNode *)parent;

@end
