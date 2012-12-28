//
//  CBCommentSet.h
//  sWiBoo
//
//  Created by ly on 12/11/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBComment.h"

@interface CBCommentSet : NSObject

@property (strong, nonatomic) NSMutableArray *list;

- (NSUInteger)count;
- (void)removeAllObjects;
- (BOOL)addComment:(CBComment *)comment;
- (CBComment *)objectAtIndex:(NSUInteger)index;

@end
