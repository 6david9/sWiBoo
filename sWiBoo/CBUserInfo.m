//
//  CBUserInfo.m
//  sWiBoo
//
//  Created by ly on 12/11/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBUserInfo.h"

@implementation CBUserInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self != nil) {
        NSString *urlStr = [dictionary valueForKey:@"profile_image_url"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"];
        
        self.userID = [dictionary valueForKey:@"idstr"];
        self.avatarURL = [NSURL URLWithString:urlStr];
        self.name = [dictionary valueForKey:@"screen_name"];
        self.weiboCount = [[dictionary valueForKey:@"statuses_count"] stringValue];
        self.followerCount = [[dictionary valueForKey:@"followers_count"] stringValue];
        self.friendsCount = [[dictionary valueForKey:@"friends_count"] stringValue];
    }
    
    return self;
}


@end
