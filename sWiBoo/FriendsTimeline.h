//
//  FriendsTimeline.h
//  sWiBoo
//
//  Created by ly on 11/7/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RetweetedStatus, UserInfo;

@interface FriendsTimeline : NSManagedObject

@property (nonatomic, retain) NSString * bmiddle_pic;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * favorited;
@property (nonatomic, retain) NSString * original_pic;
@property (nonatomic, retain) NSNumber * reposts_count;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSNumber * status_id;
@property (nonatomic, retain) NSString * status_idstr;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * thumbnail_pic;
@property (nonatomic, retain) NSNumber * truncated;
@property (nonatomic, retain) UserInfo *user;
@property (nonatomic, retain) RetweetedStatus *retweet_status;

@end
