//
//  CBStatusCell.h
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStatusContentView.h"

//

@interface CBStatusCell : UITableViewCell

@property (strong, nonatomic) NSString *statusID;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *repostText;
@property (strong, nonatomic) UIImage *repostImage;
@property (strong, nonatomic) NSURL *repostImageURL;

@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSNumber *commentCount;
@property (strong, nonatomic) NSNumber *repostCount;

- (CGFloat)height;

@end
