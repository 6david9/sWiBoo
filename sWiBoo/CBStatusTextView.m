//
//  CBStatusTextView.m
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusTextView.h"

#define kImageWidth     50
#define kImageHeight    50
#define kScreenWidth    320

@implementation CBStatusTextView

@synthesize textContentLabel = _textContentLabel;
@synthesize imageContentView = _imageContentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIFont *)defaultFont
{
    return [UIFont systemFontOfSize:13.0f];
}

- (UILabel *)textContentLabel
{
    if (_textContentLabel == nil) {
        _textContentLabel = [[UILabel alloc] init];
        _textContentLabel.numberOfLines = 0;
        _textContentLabel.font = [self defaultFont];
        _textContentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textContentLabel];
    }
    return _textContentLabel;
}

- (UIImageView *)imageContentView
{
    if (_imageContentView == nil) {
        _imageContentView = [[UIImageView alloc] init];
        _imageContentView.backgroundColor = [UIColor clearColor];
        _imageContentView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageContentView];
    }
    return _imageContentView;
}

- (CGSize)textSize: (NSString *)text
{
    CGFloat width = self.bounds.size.width;
    CGSize constrainedSize = CGSizeMake(width, 1000);
    CGSize newSize = [text sizeWithFont:[self defaultFont] constrainedToSize:constrainedSize];
    return newSize;
}

- (void)drawRect:(CGRect)rect
{
    if ( (_textContentLabel != nil) && (_textContentLabel.text != nil) ) {
        /* 添加文字 */
        CGRect textRect = CGRectZero;
        textRect.size = [self textSize:_textContentLabel.text];
        [_textContentLabel.text drawInRect:textRect withFont:[self defaultFont]];
        
        /* 添加图片 */
        if ( (_imageContentView != nil) && (_imageContentView.image != nil) ) {
            CGRect imageRect = CGRectMake(0, [self textSize:_textContentLabel.text].height, kImageWidth, kImageHeight);
            [_imageContentView.image drawInRect:imageRect];
        }
    }
}

- (CGSize)neededSize
{
    CGSize newSize = CGSizeZero;
    
    if ( (_textContentLabel != nil) && (_textContentLabel.text != nil) ) {
        /* 添加文字后的大小 */
        newSize.width = self.bounds.size.width;
        newSize.height = [self textSize:_textContentLabel.text].height;
        
        
        /* 添加图片后的大小 */
        if ( (_imageContentView != nil) && (_imageContentView.image != nil) ) {
            newSize.height = [self textSize:_textContentLabel.text].height + kImageHeight;
        }
    }
    
    return newSize;
}

@end
