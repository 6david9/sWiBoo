//
//  Status.h
//  sWiBoo
//
//  Created by ly on 12/4/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Status : NSManagedObject

@property (nonatomic, retain) NSString * status_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSString * repost_text;
@property (nonatomic, retain) NSString * repost_image_url;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSNumber * comment_count;
@property (nonatomic, retain) NSNumber * repost_count;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * repost_screen_name;
@property (nonatomic, retain) NSDate * created_at;

@end
