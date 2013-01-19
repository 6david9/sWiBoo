//
//  CBStatusSet.h
//  CBStatusSet
//
//  Created by ly on 12/9/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBStatus.h"

@interface CBStatusSet : NSObject

@property (strong, nonatomic) NSMutableArray *list;

- (NSUInteger)count;
- (void)removeAllObjects;
- (void)removeObjectsInRange:(NSRange)range;
- (BOOL)addStatus:(CBStatus *)status;
- (NSInteger)addStatusesFromArray:(NSArray *)array;
- (CBStatus *)objectAtIndex:(NSUInteger)index;

@end
