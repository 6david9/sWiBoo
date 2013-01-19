//
//  CBStatusCell.m
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CBPreviewViewController.h"

@interface CBStatusCell()

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *postDateLabel;
@property (strong, nonatomic) UIView *postTextView;
@property (strong, nonatomic) UILabel *postTextLabel;
@property (strong, nonatomic) UIButton *postImageView;
@property (strong, nonatomic) UIImageView *repostTextBackgroudView;
@property (strong, nonatomic) UILabel *repostTextLabel;
@property (strong, nonatomic) UIButton *repostImageView;
@property (strong, nonatomic) UILabel *textFromLabel;
@property (strong, nonatomic) UILabel *commentAndRepostCountLabel;

- (CGFloat)height;

@end

@implementation CBStatusCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil) {
        /* 配置cell属性 */
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:240/255 green:240/255 blue:240/255 alpha:1];
        
        
        /* 分配内存 */
        self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 40, 40)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 11, 153, 14)];
        self.postDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(231, 11, 75, 14)];
        self.postTextView = [[UIView alloc] initWithFrame:CGRectMake(59, 28, 240, 18)];
        self.postTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 240, 18)];
        self.postImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.repostTextBackgroudView = [[UIImageView alloc] initWithFrame:CGRectMake(59, 59, 240, 128)];
        self.repostTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 240, 20)];
        self.repostImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.textFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 195, 120, 14)];
        self.commentAndRepostCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(187, 195, 112, 14)];
        
        
        
        /* 设置属性 */
        // 字体大小
        self.nameLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.postDateLabel.font = [UIFont systemFontOfSize:11.0f];
        self.postTextLabel.font = [UIFont systemFontOfSize:13.0f];
        self.repostTextLabel.font = [UIFont systemFontOfSize:13.0f];
        self.textFromLabel.font = [UIFont systemFontOfSize:11.0f];
        self.commentAndRepostCountLabel.font = [UIFont systemFontOfSize:11.0f];
        // 字体颜色
        self.postDateLabel.textColor = [UIColor colorWithRed:251.0/255 green:147.0/255 blue:24.0/255 alpha:1.0];
        self.textFromLabel.textColor = [UIColor colorWithRed:134.0/255 green:134.0/255 blue:134.0/255 alpha:1.0];
        self.commentAndRepostCountLabel.textColor = [UIColor grayColor];
        // 对齐方式
        self.postDateLabel.textAlignment = UITextAlignmentRight;
        self.commentAndRepostCountLabel.textAlignment = UITextAlignmentRight;
        // label行数
        self.postTextLabel.numberOfLines = 0;
        self.repostTextLabel.numberOfLines = 0;
        // 背景是否透明？
        self.repostTextLabel.backgroundColor = [UIColor clearColor];
        self.postDateLabel.backgroundColor = [UIColor whiteColor];
        // 转发背景图片
        UIImage *backgroudImage = [[UIImage imageNamed:@"timeline_rt_border_t.png"]
                                            resizableImageWithCapInsets:UIEdgeInsetsMake(7, 30, 3, 20)];
        self.repostTextBackgroudView.image = backgroudImage;
        self.repostTextBackgroudView.clipsToBounds = YES;
        self.repostTextBackgroudView.userInteractionEnabled = YES;  /* 实现repostImageView交互 */
        // 可点击图片
        self.postImageView.frame = CGRectMake(60, 60, 50, 50);
        [self.postImageView addTarget:self
                               action:@selector(postImageDidTouch:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        self.repostImageView.frame =  CGRectMake(5, 25, 50, 50);
        [self.repostImageView addTarget:self
                                 action:@selector(repostImageDidTouch:)
                       forControlEvents:UIControlEventTouchUpInside];
        // 是否显示？
        self.postTextView.hidden = YES;
        self.postTextLabel.hidden = YES;
        self.postImageView.hidden = YES;
        self.repostTextBackgroudView.hidden = YES;
        self.repostTextLabel.hidden = YES;
        self.repostImageView.hidden = YES;
        self.textFromLabel.hidden = YES;
        self.commentAndRepostCountLabel.hidden = YES;
        // 头像layer圆角
        CALayer *avatarViewLayer = self.avatarView.layer;
        avatarViewLayer.masksToBounds = YES;
        avatarViewLayer.cornerRadius = 4;
        
        
        /* 加入到当前视图 */
        [self addSubview:self.avatarView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.postDateLabel];
        
        [self addSubview:self.postTextView];
        [self.postTextView addSubview:self.postTextLabel];
        [self.postTextView addSubview:self.postImageView];
        
        [self addSubview:self.repostTextBackgroudView];
        [self.repostTextBackgroudView addSubview:self.repostTextLabel];
        [self.repostTextBackgroudView addSubview:self.repostImageView];
        
        [self addSubview:self.textFromLabel];
        [self addSubview:self.commentAndRepostCountLabel];
    }
    
    return self;
}

- (void)prepareForReuse
{
    
}


#pragma mark - Cell Height
- (CGFloat)height
{
    BOOL hasText = (self.text!=nil ? YES:NO);
    BOOL hasPostText = (self.repostTextBackgroudView.hidden ? NO:YES);
    
    CGFloat height = 0;
    
    if (hasText && hasPostText)
    {
        height = 25 + 3 + self.postTextView.frame.size.height + 3 + self.repostTextBackgroudView.frame.size.height + 3 + 14 + 6;
    }
    else if (hasText) {
        height = 25 + 3 + self.postTextView.frame.size.height + 3 + 14 + 6;
    }
    else if (hasPostText) {
        height = 25 + 3 + self.repostTextBackgroudView.frame.size.height + 3 + 14 + 6;
    }
    
//    height = 280;
    
    return height;
}


#pragma mark - Property Setter
- (void)setName:(NSString *)name
{
    _name = name;
    
    self.nameLabel.text = name;
}

- (void)setText:(NSString *)text andImageWithURL:(NSURL *)imageURL
{
    @autoreleasepool {
        // 保存引用
        _text = text;
        _imageURL = imageURL;
        
        BOOL hasText = (text!=nil ? YES:NO);
        BOOL hasImage = (imageURL!=nil ? YES:NO);
        
        // 是否需要显示?
        self.postTextView.hidden = (hasText||hasImage ? NO:YES);
        
        // 调整内部位置
        if (hasText && hasImage) {
            CGSize calcSize = [self fitSizeForLabelText:text];
            self.postTextLabel.frame = CGRectMake(0, 0, 240, calcSize.height);
            
            CGFloat y = self.postTextLabel.frame.size.height + 5;
            self.postImageView.frame = CGRectMake(0, y, 50, 50);
        }
        else if (hasText) {
            CGSize calcSize;
            calcSize = [self fitSizeForLabelText:text];
            self.postTextLabel.frame = CGRectMake(0, 0, 240, calcSize.height);
        }
        else if (hasImage) {
            self.postImageView.frame = CGRectMake(0, 5, 50, 50);
        }
        self.postTextLabel.hidden = !hasText;
        self.postImageView.hidden = !hasImage;
        
        // 调整外部距离
        CGSize postTextViewSize = [self fitSizeForPostText:text andImage:hasImage];
        self.postTextView.frame = CGRectMake(59, 28, 240, postTextViewSize.height);
        
        
        
        self.postTextLabel.text = text;
        [self.postImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"avatar_default_big.png"]];
    }
}

- (void)setAvatarURL:(NSURL *)avatarURL
{
    _avatarURL = avatarURL;
    
    [self.avatarView setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"avatar_default_big.png"]];
}

- (void)setPostDate:(NSDate *)postDate
{
    _postDate = postDate;
    
    NSString *dateString = [self dateStringFromDate:postDate];
    
    self.postDateLabel.text = dateString;
}

- (void)setRepostText:(NSString *)repostText andRepostImageWithURL:(NSURL *)repostImageURL
{
    // 保留引用
    self.repostText = repostText;
    self.repostImageURL = repostImageURL;
    
    // 赋值
    self.repostTextLabel.text = repostText;
    [self.repostImageView setImageWithURL:repostImageURL
                         placeholderImage:[UIImage imageNamed:@"avatar_default_big.png"]];
    
    // 是否显示转发视图
    if (repostText!=nil || repostImageURL!=nil)
        self.repostTextBackgroudView.hidden = NO;
    else
        self.repostTextBackgroudView.hidden = YES;
    
    /* 调整位置 */
    BOOL hasRepostText = (repostText!=nil ? YES:NO);
    BOOL hasImage = (repostImageURL!=nil ? YES:NO);
    self.repostTextLabel.hidden = (hasRepostText ? NO:YES);
    self.repostImageView.hidden = (hasImage ? NO:YES);
    
    if (hasRepostText && hasImage)
    {
        CGSize repostTextSize = [self fitSizeForLabelText:repostText];
        self.repostTextLabel.frame = CGRectMake(5, 6, 230, repostTextSize.height);
        self.repostImageView.frame = CGRectMake(5, 6+repostTextSize.height+5, 50, 50);
    }
    else if (hasRepostText)
    {
        CGSize repostTextSize = [self fitSizeForLabelText:repostText];
        self.repostTextLabel.frame = CGRectMake(5, 6, 230, repostTextSize.height);
    }
    else if (hasImage)
    {
        self.repostImageView.frame = CGRectMake(5, 6, 50, 50);
    }
    
    BOOL hasText = (self.postTextLabel.hidden ? NO:YES);
    CGFloat y;
    if (hasText) {
        y = self.postTextView.frame.origin.y + self.postTextView.frame.size.height + 3;
    } else {
        y = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 3;
    }
    
    CGSize backgroudViewSize = [self fitSizeForRepostText:repostText andRepostImage:hasImage];
    self.repostTextBackgroudView.frame = CGRectMake(59, y, 240, backgroudViewSize.height);
}

- (void)setTextFrom:(NSString *)textFrom
{
    _textFrom = textFrom;
    
    self.textFromLabel.hidden = (textFrom!=nil ? NO:YES);
    
    // 调整位置
    BOOL hasText = (self.text!=nil ? YES:NO);
    BOOL hasRepostText = (self.repostTextBackgroudView.hidden? NO:YES);
    
    if (hasText && hasRepostText)
    {
        CGFloat y = self.repostTextBackgroudView.frame.origin.y + self.repostTextBackgroudView.frame.size.height + 3;
        self.textFromLabel.frame = CGRectMake(59, y, 120, 14);
    }
    else if (hasText)
    {
        CGFloat y = self.postTextView.frame.origin.y + self.postTextView.frame.size.height + 3;
        self.textFromLabel.frame = CGRectMake(59, y, 120, 14);
    }
    else if (hasRepostText)
    {
        CGFloat y = self.repostTextBackgroudView.frame.origin.y + self.repostTextBackgroudView.frame.size.height + 3;
        self.textFromLabel.frame = CGRectMake(59, y, 120, 14);
    }
    
    self.textFromLabel.text = [NSString stringWithFormat:@"来自:%@", textFrom];
}

- (void)setCommentCount:(NSNumber *)commentCount andRepostCount:(NSNumber *)repostCount
{
    _commentCount = commentCount;
    _repostCount = repostCount;
    
    self.commentAndRepostCountLabel.hidden = NO;
    
    // 调整位置
    BOOL hasText = (self.text!=nil ? YES:NO);
    BOOL hasRepostText = (self.repostTextBackgroudView.hidden? NO:YES);

    if (hasText && hasRepostText)
    {
        CGFloat y = self.repostTextBackgroudView.frame.origin.y + self.repostTextBackgroudView.frame.size.height + 3;
        self.commentAndRepostCountLabel.frame = CGRectMake(187, y, 112, 14);
    }
    else if (hasText)
    {
        CGFloat y = self.postTextView.frame.origin.y + self.postTextView.frame.size.height + 3;
        self.commentAndRepostCountLabel.frame = CGRectMake(187, y, 112, 14);
    }
    else if (hasRepostText)
    {
        CGFloat y = self.repostTextBackgroudView.frame.origin.y + self.repostTextBackgroudView.frame.size.height + 3;
        self.commentAndRepostCountLabel.frame = CGRectMake(187, y, 112, 14);
    }
    
    @autoreleasepool {
        NSString *str = [NSString stringWithFormat:@"评论:%d 转发:%d",[commentCount integerValue], [repostCount integerValue]];
        self.commentAndRepostCountLabel.text = str;
        str = nil;
    }
}

#pragma mark -
- (void)postImageDidTouch:(UIButton *)sender
{
    if (self.containerViewController != nil)
    {
        CBPreviewViewController *previewerController;
        
        previewerController = [[CBPreviewViewController alloc]
                                    initWithNibName:@"CBPreviewViewController"
                                             bundle:nil];
        previewerController.imageURL = self.bigImageURL;
        previewerController.containerController = self.containerViewController;
        
        [self.containerViewController presentModalViewController:previewerController animated:NO];
    }
    
}

- (void)repostImageDidTouch:(UIButton *)sender
{
    if (self.containerViewController != nil)
    {
        CBPreviewViewController *previewerController;
        
        previewerController = [[CBPreviewViewController alloc]
                               initWithNibName:@"CBPreviewViewController"
                               bundle:nil];
        previewerController.imageURL = self.bigRepostImageURL;
        previewerController.containerController = self.containerViewController;
        
        [self.containerViewController presentModalViewController:previewerController animated:NO];
    }
}


#pragma mark - Private Method(Can not be outside calls)
- (NSString *)dateStringFromDate:(NSDate *)date
{
    NSString *dateString = nil;
    NSInteger secondsSinceNow = labs((NSInteger)[date timeIntervalSinceNow]);
    
    // 几秒前
    // 一分钟60秒
    if (secondsSinceNow < 60)
        dateString = [NSString stringWithFormat:@"%d秒前", secondsSinceNow];
    
    // 几分钟前
    // 一小时3600秒
    else if (secondsSinceNow>=60 && secondsSinceNow < 3600)
        dateString = [NSString stringWithFormat:@"%d分钟前", secondsSinceNow/60];
    
    // 几小时前
    // 一天216000秒 3600*24
    else if (secondsSinceNow >= 3600 && secondsSinceNow < 86400)
        dateString = [NSString stringWithFormat:@"%d小时前", secondsSinceNow/3600];
    
    // 几天前
    else if (secondsSinceNow>=86400) {
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:unitFlags fromDate:date];
        dateString = [NSString stringWithFormat:@"%d-%d-%d", components.year, components.month, components.day];
    }
    
    return dateString;
}


- (CGSize)fitSizeForLabelText:(NSString *)text
{
    CGSize retSize = CGSizeZero;
    @autoreleasepool {
        CGSize constrainedSize = CGSizeMake(230, 1000);
        
        retSize =  [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constrainedSize];
    }
    return retSize;
}

- (CGSize)fitSizeForRepostText:(NSString *)repostText andRepostImage:(BOOL)hasImage
{
    CGSize calcSize = [self fitSizeForLabelText:repostText];
    calcSize.height += 12;  /* 上下边距，上6pt，下6pt */
    calcSize.height += (hasImage ? 50:0); /* 图片高度 */
    calcSize.height += (hasImage ? 5:0);  /* 图片与文字间距 */
    
    return calcSize;
}

- (CGSize)fitSizeForPostText:(NSString *)postText andImage:(BOOL)hasImage
{
    CGSize calcSize = [self fitSizeForLabelText:postText];
    calcSize.height += (hasImage ? 60: 0);  /* 图片高度50pt, 图片上下边距各5pt */
    
    return calcSize;
}

@end