//
//  CBComment.h
//  sWiBoo
//
//  Created by ly on 12/11/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBComment : NSObject

@property (strong, nonatomic) NSString *commentID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSURL *avatarURL;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
