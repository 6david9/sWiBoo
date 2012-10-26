//
//  UserInfo.h
//  sWiBoo
//
//  Created by ly on 10/25/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FriendsTimeline;

@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) FriendsTimeline *status;

@end
