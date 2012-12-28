//
//  CBCommentSet.m
//  sWiBoo
//
//  Created by ly on 12/11/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBCommentSet.h"

@interface CBCommentSet ()

@property (strong, nonatomic) NSMutableSet *IDSet;
- (BOOL)containsComment:(CBComment *)comment;

@end

@implementation CBCommentSet

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

- (BOOL)addComment:(CBComment *)comment
{
    if (comment!=nil && ![self containsComment:comment]) {
        [self.list addObject:comment];
        [self.IDSet addObject:comment.commentID];
        return YES;
    }
    return NO;
}

- (CBComment *)objectAtIndex:(NSUInteger)index
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

- (BOOL)containsComment:(CBComment *)comment
{
    if ([self.IDSet containsObject:comment.commentID])
        return YES;
    
    return NO;
}


@end
