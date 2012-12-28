//
//  CBUserInfo.h
//  sWiBoo
//
//  Created by ly on 12/11/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBUserInfo : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *weiboCount;
@property (strong, nonatomic) NSString *followerCount;
@property (strong, nonatomic) NSString *friendsCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
