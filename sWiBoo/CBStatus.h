//
//  CBStatus.h
//  CBStatusCell
//
//  Created by ly on 12/2/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBStatus : NSObject

@property (strong, nonatomic) NSString *statusID;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *repostText;
@property (strong, nonatomic) NSURL *repostImageURL;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSNumber *commentCount;
@property (strong, nonatomic) NSNumber *repostCount;
@property (strong, nonatomic) NSString *screen_name;
@property (strong, nonatomic) NSString *repost_screen_name;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
