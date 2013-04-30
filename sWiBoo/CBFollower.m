//
//  CBFollower.m
//  sWiBoo
//
//  Created by ly on 12/9/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBFollower.h"

@implementation CBFollower

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self != nil) {
        // do some initial
        @autoreleasepool {
            self.uid = [dict valueForKey:@"idstr"];
            self.screen_name = [dict valueForKey:@"screen_name"];
        }
    }
    return self;
}

@end
