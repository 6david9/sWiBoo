//
//  CBStatusCell.m
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusCell.h"

@implementation CBStatusCell

@synthesize avatarImageView         = _avatarImageView;
@synthesize retweetedCountLabel     = _retweetedCountLabel;
@synthesize commentCountLabel       = _commentCountLabel;
@synthesize retweetedCountImageView = _retweetedCountImageView;
@synthesize commentCountImageView   = _commentCountImageView;
@synthesize mainContentView         = _mainContentView;

- (void)prepareForReuse
{
    self.avatarImageView.image = [UIImage imageNamed:@"avatar_default_big.png"];
    self.retweetedCountImageView.image = [UIImage imageNamed:@"timeline_retweet_count_icon.png"];
    self.commentCountImageView.image = [UIImage imageNamed:@"timeline_comment_count_icon.png"];
    self.retweetedCountLabel.text = @"0";
    self.commentCountLabel.text = @"0";
    
    if (_mainContentView != nil)
        [_mainContentView reset];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.retweetedCountLabel];
        [self.contentView addSubview:self.commentCountLabel];
        [self.contentView addSubview:self.retweetedCountImageView];
        [self.contentView addSubview:self.commentCountImageView];
        [self.contentView addSubview:self.mainContentView];
    }
    return self;
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.frame = CGRectMake(266, 7, 44, 44);
        _avatarImageView.image = [UIImage imageNamed:@"avatar_default_big.png"];
        NSLog(@"image:%@", _avatarImageView.image);
    }
    return _avatarImageView;
}

- (UILabel *)retweetedCountLabel
{
    if (_retweetedCountLabel == nil) {
        _retweetedCountLabel = [[UILabel alloc] init];
        _retweetedCountLabel.backgroundColor = [UIColor clearColor];
        _retweetedCountLabel.frame = CGRectMake(279, 57, 35, 15);
        _retweetedCountLabel.text = @"0"; 
    }
    return _retweetedCountLabel;
}

- (UILabel *)commentCountLabel
{
    if (_commentCountLabel == nil) {
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.backgroundColor = [UIColor clearColor];
        _commentCountLabel.frame = CGRectMake(279, 76, 35, 15);
        _commentCountLabel.text = @"0";
    }
    return _commentCountLabel;
}

- (UIImageView *)retweetedCountImageView
{
    if (_retweetedCountImageView == nil) {
        _retweetedCountImageView = [[UIImageView alloc] init];
        _retweetedCountImageView.frame = CGRectMake(266, 59, 12, 12);
        _retweetedCountImageView.image = [UIImage imageNamed:@"timeline_retweet_count_icon.png"];
    }
    return _retweetedCountImageView;
}

- (UIImageView *)commentCountImageView
{
    if (_commentCountImageView == nil) {
        _commentCountImageView = [[UIImageView alloc] init];
        _commentCountImageView.frame = CGRectMake(266, 78, 12, 12);
        _commentCountImageView.image = [UIImage imageNamed:@"timeline_comment_count_icon.png"];
    }
    return _commentCountImageView;
}

- (UIView *)mainContentView
{
    if (_mainContentView == nil) {
        _mainContentView = [[CBStatusContentView alloc] init];
        _mainContentView.frame = CGRectMake(10, 7, 248, 82);
        _mainContentView.backgroundColor = [UIColor clearColor];
    }
    return _mainContentView;
}

- (void)setText:(NSString *)text
{
    [self.mainContentView setText:text];
}

- (void)setImage:(UIImage *)image
{
    [self.mainContentView setImage:image];
}

- (void)setRetweetedText:(NSString *)retweetedText
{
    [self.mainContentView setRetweetedText:retweetedText];
}

- (void)setRetweetedImage:(UIImage *)retweetedImage
{
    [self.mainContentView setRetweetedImage:retweetedImage];
}
@end
