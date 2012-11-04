//
//  Follower.h
//  sWiBoo
//
//  Created by ly on 11/4/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Follower : NSManagedObject

@property (nonatomic, retain) NSString * idstr;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * follow_me;

@end
