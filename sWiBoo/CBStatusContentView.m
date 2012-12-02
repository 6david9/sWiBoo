//
//  CBStatusContentView.m
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusContentView.h"
#import "UIView+CBResizeView.h"

@interface CBStatusContentView()

- (void)resizeView:(UIView *)view withNewSize:(CGSize)newSize;

@end

@implementation CBStatusContentView

@synthesize textView                = _textView;
@synthesize retweetView             = _retweetView;

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)reset
{
    if (_textView != nil)
        [_textView removeFromSuperview], _textView = nil;
    
    if (_retweetView != nil)
        [_retweetView removeFromSuperview], _retweetView = nil;
}

- (CBStatusTextView *)textView
{
    if (_textView == nil) {
        _textView = [[CBStatusTextView alloc] init];
        _textView.backgroundColor = [UIColor redColor];
        _textView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        [self addSubview:_textView];
    }
    return _textView;
}

- (CBStatusTextView *)retweetView
{
    if (_retweetView == nil) {
        _retweetView = [[CBStatusTextView alloc] init];
        _retweetView.backgroundColor = [UIColor yellowColor];
        _retweetView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        [self addSubview:_retweetView];
    }
    return _retweetView;
}

- (void)setText:(NSString *)text
{
    self.textView.textContentLabel.text = text;
}

- (void)setImage:(UIImage *)image
{
    self.textView.imageContentView.image = image;
}

- (void)setRetweetedText:(NSString *)retweetedText
{
    self.retweetView.textContentLabel.text = retweetedText;
}

- (void)setRetweetedImage:(UIImage *)retweetedImage
{
    self.retweetView.imageContentView.image = retweetedImage;
}

- (CGSize)neededSize
{
    CGSize newSize = CGSizeZero;
    
    if (_textView != nil) {
        newSize.width = self.bounds.size.width;
        newSize.height = [_textView neededSize].height;
        
        if (_retweetView != nil) {
            newSize.height = [_textView neededSize].height + [_retweetView neededSize].height;
        }
    }
    
    return newSize;
}

- (void)layoutSubviews
{
    if (_textView) {
        [UIView resizeView:_textView withNewSize:[_textView neededSize]];
        
        if (_retweetView) {
            CGSize newSize = [_retweetView neededSize];
            CGRect newFrame = CGRectMake(0, _textView.frame.size.height, newSize.width, newSize.height);
            _retweetView.frame = newFrame;
        }
    }  
}


@end
