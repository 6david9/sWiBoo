//
//  CBUserInfoCell.m
//  CBUserInfo
//
//  Created by ly on 12/10/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBUserInfoCell.h"

@implementation CBUserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 120, 120)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 13, 144, 21)];
        self.weiboTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 59, 51, 21)];
        self.weiboTextLabel.text = NSLocalizedString(@"微博:", @"微博数");
        self.followerTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 84, 57, 21)];
        self.followerTextLabel.text = NSLocalizedString(@"粉丝:", @"粉丝数");
        self.friendsTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 108, 57, 21)];
        self.friendsTextLabel.text = NSLocalizedString(@"关注:", @"关注数");
        self.weiboCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(213, 59, 87, 21)];
        self.followerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(213, 84, 87, 21)];
        self.friendsCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(213, 108, 87, 21)];
        
        [self.contentView addSubview:self.avatar];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.weiboTextLabel];
        [self.contentView addSubview:self.followerTextLabel];
        [self.contentView addSubview:self.friendsTextLabel];
        [self.contentView addSubview:self.weiboCountLabel];
        [self.contentView addSubview:self.followerCountLabel];
        [self.contentView addSubview:self.friendsCountLabel];
    }
    
    return self;
}

- (CGFloat)height
{
    return 150;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
