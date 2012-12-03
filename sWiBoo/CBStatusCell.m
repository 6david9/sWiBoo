//
//  CBStatusCell.m
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusCell.h"
#import "CBStatusContentView.h"
#import "CBStatusTextView.h"
#import "UIImageView+WebCache.h"

@interface CBStatusCell()

@property (nonatomic, strong) CBStatusContentView *cbContentView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *commentIcon;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UIImageView *repostIcon;
@property (nonatomic, strong) UILabel *repostLabel;
- (void)adjustContentViewSize;

@end

@implementation CBStatusCell
@synthesize text = _text;
@synthesize image = _image;
@synthesize imageURL = _imageURL;
@synthesize repostText = _repostText;
@synthesize repostImage = _repostImage;
@synthesize avatarURL = _avatarURL;

@synthesize cbContentView = _cbContentView;
@synthesize avatarView = _avatarView;
@synthesize commentIcon = _commentIcon;
@synthesize repostIcon = _repostIcon;
@synthesize repostLabel = _repostLabel;

- (void)prepareForReuse
{
    self.text = nil;
    self.image = nil;
    self.repostText = nil;
    self.repostImage = nil;
    self.avatarURL = nil;
    self.commentCount = [NSNumber numberWithInt:0];
    self.repostCount = [NSNumber numberWithInt:0];
}

- (CGFloat)height
{
    CGFloat height;
    
    height = self.cbContentView.bounds.size.height + 10;
    height = (height > 90) ? height : 90;
    
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil) {
        self.clipsToBounds = YES;
        _cbContentView = [[CBStatusContentView alloc] initWithFrame:CGRectMake(7, 7, 240, 0)];
        [self addSubview:_cbContentView];
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 7, 50, 50)];
        [self addSubview:_avatarView];
     
        _commentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_comment_count_icon.png"]];
        _commentIcon.frame = CGRectMake(260, 60, 12, 12);
        [self addSubview:_commentIcon];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 60, 35, 12)];
        [_commentLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_commentLabel setText:@"0"];
        [self addSubview:_commentLabel];
        
        _repostIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_retweet_count_icon.png"]];
        _repostIcon.frame = CGRectMake(260, 75, 12, 12);
        [self addSubview:_repostIcon];
        
        _repostLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 75, 35, 12)];
        [_repostLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_repostLabel setText:@"0"];
        [self addSubview:_repostLabel];
    }
    
    return self;
}

- (void)adjustContentViewSize
{
    CGFloat height = [self.cbContentView height];
    CGRect frame = self.cbContentView.frame;
    frame.size.height = height;
    self.cbContentView.frame = frame;
}

- (void)setText:(NSString *)text
{
    if (![_text isEqualToString:text]) {
        _text = nil;
        _text = text;
    }
    
    [self.cbContentView addText:_text];
    [self adjustContentViewSize];
}

- (void)setImage:(UIImage *)image
{
    if (![_image isEqual:image]) {
        _image = nil;
        _image = image;
    }
    
    [self.cbContentView addImage:_image];
    [self adjustContentViewSize];
}

- (void)setImageURL:(NSURL *)imageURL
{
    if (![_imageURL isEqual:imageURL]) {
        _imageURL = nil;
        _imageURL = imageURL;
    }
    
    [self.cbContentView addimageWithURL:imageURL];
    [self adjustContentViewSize];
}

- (void)setRepostText:(NSString *)repostText
{
    if (![_repostText isEqualToString:repostText]) {
        _repostText = nil;
        _repostText = repostText;
    }
    
    [self.cbContentView addrepostText:_repostText];
    [self adjustContentViewSize];
}

- (void)setRepostImage:(UIImage *)repostImage
{
    if (![_repostImage isEqual:repostImage]) {
        _repostImage = nil;
        _repostImage = repostImage;
    }
    
    [self.cbContentView addRepostImage:_repostImage];
    [self adjustContentViewSize];
}

- (void)setRepostImageURL:(NSURL *)repostImageURL
{
    if (![_repostImageURL isEqual:repostImageURL]) {
        _repostImageURL = nil;
        _repostImageURL = repostImageURL;
    }
    
    [self.cbContentView addRepostImageURL:repostImageURL];
    [self adjustContentViewSize];
}

- (void)setAvatarURL:(NSURL *)avatarURL
{
    [self.avatarView setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"avatar_default_big.png"]];
}

- (void)setCommentCount:(NSNumber *)commentCount
{
    [self.commentLabel setText:[commentCount stringValue]];
}

- (void)setRepostCount:(NSNumber *)repostCount
{
    [self.repostLabel setText:[repostCount stringValue]];
}

@end;