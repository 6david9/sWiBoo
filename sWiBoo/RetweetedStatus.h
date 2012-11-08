//
//  RetweetedStatus.h
//  sWiBoo
//
//  Created by ly on 11/7/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FriendsTimeline;

@interface RetweetedStatus : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * retweet_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * thumbnail_pic;
@property (nonatomic, retain) NSString * bmiddle_pic;
@property (nonatomic, retain) NSString * original_pic;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) FriendsTimeline *status;

@end
