//
//  CBTimelineContentView.m
//  sWiBoo
//
//  Created by ly on 10/25/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBTimelineContentView.h"
#import "UIImageView+AsynImage.h"

@interface CBTimelineContentView ()


@end

@implementation CBTimelineContentView

@synthesize textHeight = _textHeight;

- (void)setText:(NSString *)text andImageWithURL:(NSURL *)URL width:(CGFloat)width
{
    _text = text;
    _width = width;
    NSAssert( (_text != nil) && (_width > 0), @"error: _text属性和_width属性未正确赋值");
    
    if (URL != nil) {
        _hasImage = YES;

        _imageView = [[UIImageView alloc] init];
        [_imageView setImageWithURL:URL];
        NSAssert(_imageView!= nil, @"imageview is nil");
    }
    
    [self setNeedsDisplay];
}

- (void)resetContent
{
    // 清除图片
    _imageView.image = nil;
    _imageView = nil;
    _hasImage = NO;
    
    // 重置frame大小
    self.frame = CGRectMake(20, 43, 280, 21);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat fontSize = 13.0f;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];

    // 绘制文字
    CGRect drawingRect = self.bounds;
    [_text drawInRect:drawingRect withFont:systemFont];
    
    // 绘制图片
    if (_hasImage) {
        _imageView.frame = CGRectMake(0, 3 + _textHeight, 100, 100);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        // 调整图片位置为水平居中
        CGFloat imageX = self.bounds.size.width/2;
        CGFloat imageY = _imageView.center.y;
        _imageView.center = CGPointMake(imageX, imageY);
    }
}

@end
