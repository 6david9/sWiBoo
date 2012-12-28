//
//  CBStatus.m
//  CBStatusCell
//
//  Created by ly on 12/2/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatus.h"

@implementation CBStatus

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil) {
        self.statusID = [dictionary valueForKey:@"idstr"];
        self.text = [dictionary valueForKey:@"text"];
        self.imageURL = [NSURL URLWithString:[dictionary valueForKey:@"bmiddle_pic"]];
        self.repostText = [[dictionary valueForKey:@"retweeted_status"] valueForKey:@"text"];
        self.repostImageURL = [NSURL URLWithString:[[dictionary valueForKey:@"retweeted_status"] valueForKey:@"bmiddle_pic"]];
        self.commentCount = [dictionary valueForKey:@"comments_count"];
        self.repostCount = [dictionary valueForKey:@"reposts_count"];
        self.avatarURL = [NSURL URLWithString:[[dictionary valueForKey:@"user"] valueForKey:@"profile_image_url"]];
        self.screen_name = [[dictionary valueForKey:@"user"] valueForKey:@"screen_name"];
        self.repost_screen_name = [[[dictionary valueForKey:@"retweeted_status"] valueForKey:@"user"]  valueForKey:@"screen_name"];
    }
    
    return self;
}

- (NSString *)description
{
    return self.statusID;
}

@end
