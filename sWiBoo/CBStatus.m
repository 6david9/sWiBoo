//
//  CBStatus.m
//  CBStatusCell
//
//  Created by ly on 12/2/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatus.h"

@interface CBStatus()

- (NSString *)sourceString:(NSString *)rawSource;

@end

@implementation CBStatus

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self != nil) {
        @autoreleasepool {
            self.statusID = [dictionary valueForKey:@"idstr"];
            self.text = [dictionary valueForKey:@"text"];
            self.imageURL = [NSURL URLWithString:[dictionary valueForKey:@"thumbnail_pic"]];
            self.repostText = [[dictionary valueForKey:@"retweeted_status"] valueForKey:@"text"];
            self.repostImageURL = [NSURL URLWithString:[[dictionary valueForKey:@"retweeted_status"] valueForKey:@"thumbnail_pic"]];
            self.commentCount = [dictionary valueForKey:@"comments_count"];
            self.repostCount = [dictionary valueForKey:@"reposts_count"];
            self.avatarURL = [NSURL URLWithString:[[dictionary valueForKey:@"user"] valueForKey:@"profile_image_url"]];
            self.screen_name = [[dictionary valueForKey:@"user"] valueForKey:@"screen_name"];
            self.repost_screen_name = [[[dictionary valueForKey:@"retweeted_status"] valueForKey:@"user"]  valueForKey:@"screen_name"];
            self.fromText = [self sourceString:[dictionary valueForKey:@"source"]];
            NSString *dataStr = [dictionary valueForKey:@"created_at"];
            NSDate *aDate = [self dateFromString:dataStr];
            self.postDate = aDate;
            dataStr = nil;
            aDate = nil;
            
            
            self.bigImageURL = [NSURL URLWithString:[dictionary valueForKey:@"bmiddle_pic"]];
            self.bigRepostImageURL = [NSURL URLWithString:[[dictionary valueForKey:@"retweeted_status"] valueForKey:@"bmiddle_pic"]];
        } 
    }
    
    return self;
}

- (NSString *)sourceString:(NSString *)rawSource
{
    // <a href="http://weibo.com" rel="nofollow">新浪微博</a>
    
    NSArray *components;
    NSString *filtedString;
    
    /* 第一次分割 */
    components = [rawSource componentsSeparatedByString:@">"];
    filtedString = components[1];
    
    /* 第二次分割 */
    components = nil;
    components = [filtedString componentsSeparatedByString:@"<"];
    filtedString = nil;
    filtedString = components[0];
    
    return filtedString;
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDate *date = nil;
    
    @autoreleasepool {
        // Sun Mar 18 21:03:59 +0800 2012
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:usLocale];
        usLocale = nil;
        
        [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss v yyyy"];
        date = [dateFormatter dateFromString:dateString];
        dateFormatter = nil;
//        date = [NSDate date];
    }
    
    return date;
}

- (NSString *)description
{
    return self.statusID;
}

@end
