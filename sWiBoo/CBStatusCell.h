//
//  CBStatusCell.h
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStatusContentView.h"

@interface CBStatusCell : UITableViewCell

@property (strong, nonatomic) NSString *statusID;

@property (strong, nonatomic) UIImageView           *avatarImageView;
@property (strong, nonatomic) UILabel               *retweetedCountLabel;
@property (strong, nonatomic) UILabel               *commentCountLabel;
@property (strong, nonatomic) UIImageView           *retweetedCountImageView;
@property (strong, nonatomic) UIImageView           *commentCountImageView;
@property (strong, nonatomic) CBStatusContentView   *mainContentView;

- (void)setText:(NSString *)text;
- (void)setImage:(UIImage *)image;
- (void)setRetweetedText:(NSString *)retweetedText;
- (void)setRetweetedImage:(UIImage *)retweetedImage;

@end
