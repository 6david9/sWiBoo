//
//  CBComment.m
//  sWiBoo
//
//  Created by ly on 12/11/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBComment.h"

@implementation CBComment

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil) {
        self.commentID = [dictionary valueForKey:@"idstr"];
        self.userName = [[dictionary valueForKey:@"user"] valueForKey:@"screen_name"];
        self.text = [dictionary valueForKey:@"text"];
        self.avatarURL = [NSURL URLWithString:[[dictionary valueForKey:@"user"] valueForKey:@"profile_image_url"]];
    }
    
    return self;
}

@end
