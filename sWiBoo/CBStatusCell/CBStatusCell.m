//
//  CBStatusCell.m
//  WeiboStatusCell
//
//  Created by ly on 11/5/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusCell.h"
#import "UIImageView+AsynImage.h"

@interface CBStatusView : UIView
{
    UILabel *_whatISaidLabel;
    UIView *_originStatusView;
    
    UIImageView *_repostImageView;
}

- (void)reset;
- (void)setWhatISaid:(NSString *)text;
- (void)setRepostText:(NSString *)repostText andImageWithURL:(NSURL *)URL;

@property (nonatomic, weak) CBStatusCell *parentCell;

@end

@interface CBStatusCell (Private)

- (void)resizeCellHeight;

@end

@implementation CBStatusCell
@synthesize showPlaceholderImage = _showPlaceholderImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置cell初始frame
        self.frame = CGRectMake(0, 0, 320, 85);
        
        // 默认显示占位图片
        _showPlaceholderImage = YES;
        self.indexPath = [NSIndexPath indexPathForItem:NSIntegerMax inSection:NSIntegerMax];
        
        // 设置cell本身的contentMode
        self.contentMode = UIViewContentModeRedraw;
        self.clearsContextBeforeDrawing = YES;
        
        // 设置头像视图
        _avatarView = [[UIImageView alloc] init];
        _avatarView.frame = CGRectMake(10, 10, 25, 25);
        _avatarView.image = _showPlaceholderImage ? [UIImage imageNamed:@"avatar_default_big.png"] : nil;
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_avatarView];
        
        // 设置姓名label
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(43, 10, 139, 21);
        _nameLabel.font = [UIFont systemFontOfSize:13.0f];
        _nameLabel.contentMode = UIViewContentModeLeft;
        _nameLabel.text = @"未知";
        _nameLabel.clipsToBounds = YES;
        _nameLabel.opaque = YES;
        _nameLabel.backgroundColor = [UIColor clearColor];        // 设置背景颜色
        [self.contentView addSubview:_nameLabel];
        
        // 设置评论图标
        _commentIconView = [[UIImageView alloc] init];
        _commentIconView.frame = CGRectMake(203, 17, 12, 12);
        _commentIconView.image = [UIImage imageNamed:@"timeline_comment_count_icon.png"];
        _commentIconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_commentIconView];
        
        // 设置转发图标
        _repostIconView = [[UIImageView alloc] init];
        _repostIconView.frame = CGRectMake(249, 17, 12, 12);
        _repostIconView.image = [UIImage imageNamed:@"timeline_retweet_count_icon.png"];
        _repostIconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_repostIconView];
        
        // 设置评论数字label
        _numCommentLabel = [[UILabel alloc] init];
        _numCommentLabel.frame = CGRectMake(218, 15, 38, 16);
        _numCommentLabel.contentMode = UIViewContentModeLeft;
        _numCommentLabel.font = [UIFont systemFontOfSize:13.0f];
        _numCommentLabel.text = @"0";
        _numCommentLabel.opaque = NO;
        _numCommentLabel.clipsToBounds = YES;
        _numCommentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_numCommentLabel];
        
        // 设置转发数字label
        _numRepostLabel = [[UILabel alloc] init];
        _numRepostLabel.frame = CGRectMake(265, 15, 42, 16);
        _numRepostLabel.contentMode = UIViewContentModeLeft;
        _numRepostLabel.font = [UIFont systemFontOfSize:13.0f];
        _numRepostLabel.text = @"0";
        _numRepostLabel.opaque = NO;
        _numRepostLabel.clipsToBounds = YES;
        _numRepostLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_numRepostLabel];
        
        // 设置微博正文视图
        _statusView = [[CBStatusView alloc] init];
        _statusView.parentCell = self;
        _statusView.backgroundColor = [UIColor clearColor];
        _statusView.frame = CGRectMake(20, 43, 280, 0);
        _statusView.clipsToBounds = YES;
        _statusView.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:_statusView];   
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
    // 获取屏幕高度和宽度
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    
    CGFloat screenWidth = 0.0f;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            screenWidth = screenFrame.size.width;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            screenWidth = screenFrame.size.height;
            break;
            
        default:
            screenWidth = screenFrame.size.width;
            break;
    }
    
    /* 头像 
     * 位置不变，宽度高度不拉伸
     */
    _avatarView.frame = CGRectMake(10, 10, 25, 25);
    
    /* 姓名 
     * 左侧距离保持不变，宽度按比例拉伸
     */
    _nameLabel.frame = CGRectMake(43, 10, 139/320.0f * screenWidth, 21);
    
    /* 评论图标 
     * 右侧距离不变，宽度高度不拉伸
     */
    _commentIconView.frame = CGRectMake(screenWidth-(320-203), 17, 12, 12);
    
    /* 转发图标 
     * 右侧距离不变，宽度高度不拉伸
     */
    _repostIconView.frame = CGRectMake(screenWidth-(320-249), 17, 12, 12);
    
    /* 评论数字label 
     * 右侧距离不变，宽度高度不拉伸
     */
    _numCommentLabel.frame = CGRectMake(screenWidth-(320-218), 15, 38, 16);
    
    /* 转发数字label 
     * 右侧距离不变，宽度高度不拉伸
     */
    _numRepostLabel.frame = CGRectMake(screenWidth-(320-265), 15, 42, 16);
    
    /* 微博正文视图
     * 上下左右距离不变，宽度高度按比例拉伸
     */
    _statusView.frame = CGRectMake(20, 43, 280/320.0f * screenWidth, _statusView.bounds.size.height);
    CGFloat statusHeight = _statusView.bounds.size.height;
    
    /* 消息源label 
     * 左侧距离不变，下部距离不变，宽度高度不拉伸
     */
    if (_showFromLabel) {
        _fromLabel.frame = CGRectMake(10, 62 + statusHeight, 30, 16);
        _textFromLabel.frame = CGRectMake(43, 59 + statusHeight, 148, 21);
    }
    
    /* 时间标签 
     * 右侧距离不变,下部距离不变，宽度高度不拉伸
     */
    if (_showTimeLabel)
        _timeLabel.frame = CGRectMake(screenWidth-(320-237), 57 + statusHeight, 63, 21);
    
}

#pragma mark - Public method
-(void)prepareForReuse
{
    [_statusView reset];
    
    _showFromLabel = NO;
    _showTimeLabel = NO;
    _showPlaceholderImage = YES;        // 默认显示占位图
    self.indexPath = [NSIndexPath indexPathForItem:NSIntegerMax inSection:NSIntegerMax];
    _avatarView.image = _showPlaceholderImage ? [UIImage imageNamed:@"avatar_default_big.png"] : nil;  
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (void)setAvatarWithURL:(NSURL *)URL;
{
    if (URL == nil)
        return;

    [_avatarView setImageWithURL:URL];
}

- (void)setName:(NSString *)name
{
    if (name == nil)
        _nameLabel.text = @"";
        
    _nameLabel.text = name;
}

- (void)setCommentCount:(NSUInteger)count;
{
    NSNumber *integerValue = [NSNumber numberWithUnsignedInteger:count];
    _numCommentLabel.text = [integerValue stringValue];
}

- (void)setRepostCount:(NSUInteger)count;
{
    NSNumber *integerValue = [NSNumber numberWithUnsignedInteger:count];
    _numRepostLabel.text = [integerValue stringValue];
}

- (void)setSourceFrom:(NSString *)from;
{
    if (from == nil)
        return;
    
    if (!_showFromLabel) {
        // 添加消息源label
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.frame = CGRectMake(10, 62, 30, 16);
        _fromLabel.font = [UIFont systemFontOfSize:13.0f];
        _fromLabel.text = NSLocalizedString(@"from:", @"消息源来自");
        _fromLabel.contentMode = UIViewContentModeBottomLeft;
        [self.contentView addSubview:_fromLabel];
        
        _textFromLabel = [[UILabel alloc] init];
        _textFromLabel.frame = CGRectMake(43, 59, 148, 21);
        _textFromLabel.font = [UIFont systemFontOfSize:13.0f];
        _textFromLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_textFromLabel];
    }
    _showFromLabel = YES;
    
    _textFromLabel.text = from;
}

- (void)setCreateTime:(NSDate *)time;
{
    if (time == nil)
        return;
    
    if (!_showTimeLabel) {
        // 设置时间标签
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.frame = CGRectMake(237, 57, 63, 21);
        _timeLabel.contentMode = UIViewContentModeRight;
        _timeLabel.textAlignment = UITextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_timeLabel];
    }
    _showTimeLabel = YES;
    
    NSString *timeStr = nil;
    NSInteger timeInterval = (NSInteger)[time timeIntervalSinceNow];
    if (timeInterval < 0) {
        timeInterval = abs(timeInterval);
        if (timeInterval >= kSecondsPerDay) {
            timeStr = [NSString stringWithFormat:@"%d天前", (NSInteger)(timeInterval/kSecondsPerDay)];
        } else if (timeInterval >= kSecondsPerHour) {
            timeStr = [NSString stringWithFormat:@"%d小时前", (NSInteger)(timeInterval/kSecondsPerHour)];
        } else if (timeInterval >= kSecondsPerMinutes) {
            timeStr = [NSString stringWithFormat:@"%d分钟前", (NSInteger)(timeInterval/kSecondsPerMinutes)];
        } else {
            timeStr = [NSString stringWithFormat:@"%d秒前", timeInterval];
        }
        
    } else
        timeStr = @"未知时间";
    
    _timeLabel.text = timeStr;
}

- (void)resizeCellHeight
{
    NSAssert(_statusView != nil, @"_statusView未正常赋值\nLine:%d\nFile:%s",__LINE__, __FILE__);
    
    CGSize newCellSize = self.bounds.size;
    newCellSize.height += _statusView.bounds.size.height;
    self.bounds = CGRectMake(0, 0, newCellSize.width, newCellSize.height);
}

- (void)setWhatISaid:(NSString *)text
{
    [_statusView setWhatISaid:text];
    
    [self resizeCellHeight];
}

- (void)setWhatISaid:(NSString *)text repostText:(NSString *)repostText andImageWithURL:(NSURL *)URL
{
    [_statusView setWhatISaid:text];
    [_statusView setRepostText:repostText andImageWithURL:URL];
    
    [self resizeCellHeight];
}

@end

@implementation CBStatusView
- (void)reset
{
    CGRect resetFrame = self.frame;
    resetFrame.size.height = 0;
    
    [_whatISaidLabel removeFromSuperview], _whatISaidLabel = nil;
    [_originStatusView removeFromSuperview], _originStatusView = nil;
    self.frame = resetFrame;
}

- (void)setWhatISaid:(NSString *)text
{
    if (text != nil) {
        if (_whatISaidLabel == nil) {
            _whatISaidLabel = [[UILabel alloc] init];
            _whatISaidLabel.backgroundColor = [UIColor clearColor];
            _whatISaidLabel.font = [UIFont systemFontOfSize:13.0f];
            _whatISaidLabel.numberOfLines = 0;
            [self addSubview:_whatISaidLabel];
        }
        
        CGSize constrainedSize = CGSizeMake(self.bounds.size.width, 1000);
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constrainedSize];
        
        _whatISaidLabel.text = text;
        _whatISaidLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
        self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + textSize.height);
    }
}

- (void)setRepostText:(NSString *)repostText andImageWithURL:(NSURL *)URL
{
    if (repostText != nil) {
        UIImageView *backgroundView = nil;
        CGFloat topAreaHeight = _whatISaidLabel ? _whatISaidLabel.bounds.size.height : 0;
        CGFloat topAreaY = _whatISaidLabel ? _whatISaidLabel.frame.origin.y : 0;
        CGFloat y = topAreaY + topAreaHeight;
        
        if (_originStatusView == nil) {
            _originStatusView = [[UIView alloc] init];
            _originStatusView.frame = CGRectMake(0, y, self.bounds.size.width, 0);
            
            UIImage *backgroudImage = [UIImage imageNamed:@"timeline_rt_border_t.png"];
            UIEdgeInsets edgeInset = UIEdgeInsetsMake(6, 30, 7, 35);
            backgroudImage = [backgroudImage resizableImageWithCapInsets:edgeInset];
            backgroundView = [[UIImageView alloc] initWithImage:backgroudImage];
            backgroundView.contentMode = UIViewContentModeScaleToFill;
            [_originStatusView addSubview:backgroundView];
            
            [self addSubview:_originStatusView];
            
        }
        
        // 添加转发文字
        CGSize constrainedSize = CGSizeMake(_originStatusView.bounds.size.width - kLeftMargin, 1000);
        CGSize textSize = [repostText sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constrainedSize];
        
        UILabel *repostTextLabel = [[UILabel alloc] init];
        repostTextLabel.backgroundColor = [UIColor clearColor];
        repostTextLabel.font = [UIFont systemFontOfSize:13.0f];
        repostTextLabel.numberOfLines = 0;
        repostTextLabel.text = repostText;
        repostTextLabel.frame = CGRectMake(kLeftMargin, kTopMargin, _originStatusView.bounds.size.width, textSize.height);
        [_originStatusView addSubview:repostTextLabel];
        
        _originStatusView.frame = CGRectMake(0, y, self.bounds.size.width, repostTextLabel.bounds.size.height + kTopMargin*2);
        backgroundView.frame = CGRectMake(0, 0, _originStatusView.bounds.size.width, _originStatusView.bounds.size.height);
        self.bounds = CGRectMake(0, 0, self.bounds.size.width, topAreaHeight + _originStatusView.bounds.size.height);
        
        // 添加转发图片
        if (URL != nil) {
            CGRect imageFrame = CGRectMake(kLeftMargin, repostTextLabel.frame.origin.y+repostTextLabel.bounds.size.height + kTopMargin, 50, 100);
            _repostImageView = [[UIImageView alloc] initWithFrame:imageFrame];
            _repostImageView.contentMode = UIViewContentModeScaleAspectFit;
            _repostImageView.userInteractionEnabled = YES;
            // 添加点击图片手势识别
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage)];
            [_repostImageView addGestureRecognizer:tapGestureRecognizer];
            
            [_repostImageView setImageWithURL:URL];
            [_originStatusView addSubview:_repostImageView];
            
            _originStatusView.frame = CGRectMake(0, y, _originStatusView.bounds.size.width, _originStatusView.bounds.size.height + imageFrame.size.height + kTopMargin);
            backgroundView.frame = CGRectMake(0, 0, _originStatusView.bounds.size.width, _originStatusView.bounds.size.height);
            self.bounds = CGRectMake(0, 0, self.bounds.size.width, topAreaHeight + _originStatusView.bounds.size.height);
        }
    }
}

- (void)zoomImage
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self.parentCell.delegate respondsToSelector:@selector(tableCell:atIndexPathWasTapped:)]) {
        [self.parentCell.delegate tableCell:self.parentCell atIndexPathWasTapped:self.parentCell.indexPath];
    }
}

@end
