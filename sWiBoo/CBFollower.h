//
//  CBFollower.h
//  sWiBoo
//
//  Created by ly on 12/9/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBFollower : NSObject

@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *screen_name;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
