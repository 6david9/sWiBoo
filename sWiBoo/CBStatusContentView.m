//
//  CBStatusContentView.m
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusContentView.h"
#import "SDWebImageManager.h"

@interface CBStatusContentView()


@property (nonatomic, strong) UIImageView *backgroudView;

- (void)adjustStatusViewSize;
- (void)adjustRepostViewSize;

@end

@implementation CBStatusContentView

@synthesize statusView = _statusView;
@synthesize backgroudView = _backgroudView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        CGRect statusViewFrame = CGRectMake(0, 0, frame.size.width, 0);
        CGRect repostStatusViewFrame = CGRectMake(8, 0, frame.size.width-8*2, 0);
        
        _statusView = [[CBStatusTextView alloc] initWithFrame:statusViewFrame];
        [_statusView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_statusView];
        
        _repostStatusView = [[CBStatusTextView alloc] initWithFrame:repostStatusViewFrame];
        [_repostStatusView setBackgroundColor:[UIColor clearColor]];
        _repostStatusView.backgroudImage = [UIImage imageNamed:@"timeline_rt_border_t.png"];
        [self addSubview:_repostStatusView];
        
        UIImage *backgroudImage = [[UIImage imageNamed:@"timeline_rt_border_t.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 30, 4, 1)];
        _backgroudView = [[UIImageView alloc] initWithImage:backgroudImage];
        _backgroudView.frame = _repostStatusView.frame;
        _backgroudView.hidden = YES;
        [self insertSubview:_backgroudView belowSubview:_repostStatusView];
    }
    
    return self;
}

- (CGFloat)height
{
    return ([self.statusView height] + [self.repostStatusView height]);
}

- (void)adjustStatusViewSize
{
    CGRect frame  = self.statusView.frame;
    CGFloat height = [self.statusView height];
    frame.size.height = height;
    self.statusView.frame = frame;
}

- (void)addText:(NSString *)text
{
    self.statusView.text = text;
    [self adjustStatusViewSize];
}

- (void)addImage:(UIImage *)image
{
    self.statusView.image = image;
    [self adjustStatusViewSize];
}

- (void)addimageWithURL:(NSURL *)imageURL
{
    [self.statusView setImageWithURL:imageURL];
    [self adjustStatusViewSize];
}

- (void)adjustRepostViewSize
{
    CGRect frame  = self.repostStatusView.frame;
    CGFloat height = [self.repostStatusView height];
    frame.size.height = height+10;
    frame.origin.y = self.statusView.frame.size.height;
    self.repostStatusView.frame = frame;
    self.backgroudView.frame = frame;
}

- (void)addrepostText:(NSString *)repostText
{
    _backgroudView.hidden = (repostText==nil) ? YES : NO;
    
    self.repostStatusView.text = repostText;
    [self adjustRepostViewSize];
}

- (void)addRepostImage:(UIImage *)repostImage
{
    _backgroudView.hidden = (repostImage==nil) ? YES : NO;
    
    self.repostStatusView.image = repostImage;
    [self adjustRepostViewSize];
}

- (void)addRepostImageURL:(NSURL *)repostImageURL
{
    _backgroudView.hidden = (repostImageURL==nil) ? YES : NO;
    
    [self.repostStatusView setImageWithURL:repostImageURL];
    [self adjustRepostViewSize];
}

@end
