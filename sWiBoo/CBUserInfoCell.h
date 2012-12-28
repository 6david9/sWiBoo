//
//  CBUserInfoCell.h
//  CBUserInfo
//
//  Created by ly on 12/10/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUserInfoCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatar;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *weiboTextLabel;
@property (strong, nonatomic) UILabel *followerTextLabel;
@property (strong, nonatomic) UILabel *friendsTextLabel;
@property (strong, nonatomic) UILabel *weiboCountLabel;
@property (strong, nonatomic) UILabel *followerCountLabel;
@property (strong, nonatomic) UILabel *friendsCountLabel;

- (CGFloat)height;

@end
