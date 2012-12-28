//
//  CBStatusSet.m
//  CBStatusSet
//
//  Created by ly on 12/9/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusSet.h"

@interface CBStatusSet ()

@property (strong, nonatomic) NSMutableSet *IDSet;
- (BOOL)containsStatus:(CBStatus *)status;

@end

@implementation CBStatusSet

- (NSMutableArray *)list
{
    if (_list == nil) {
        _list = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return _list;
}

- (NSMutableSet *)IDSet
{
    if (_IDSet == nil) {
        _IDSet = [[NSMutableSet alloc] initWithCapacity:20];
    }
    return _IDSet;
}

- (void)removeAllObjects
{
    [self.list removeAllObjects];
    [self.IDSet removeAllObjects];
}

- (BOOL)addStatus:(CBStatus *)status
{
    if (status!=nil && ![self containsStatus:status]) {
        [self.list addObject:status];
        [self.IDSet addObject:status.statusID];
        return YES;
    }
    return NO;
}

- (CBStatus *)objectAtIndex:(NSUInteger)index
{
    if ([self.list count] == 0)
        return nil;
    
    return [self.list objectAtIndex:index];
}

- (NSString *)description
{
    NSString *mstr = [NSMutableString stringWithString:@"{\n"];

    for (int i = 0; i <[self.list count]; i++) {
        mstr = [mstr stringByAppendingFormat:@"    %@\n",[self.list objectAtIndex:i]];
    }
    
    mstr = [mstr stringByAppendingFormat:@"}\n"];
    
    
    return mstr;
}

- (NSUInteger)count
{
    return [self.list count];
}

- (BOOL)containsStatus:(CBStatus *)status
{
    if ([self.IDSet containsObject:status.statusID])
        return YES;
    
    return NO;
}

@end
