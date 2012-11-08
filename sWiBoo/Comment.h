//
//  Comment.h
//  sWiBoo
//
//  Created by ly on 11/4/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * comment_id;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * status_id;

@end
