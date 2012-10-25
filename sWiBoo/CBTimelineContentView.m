//
//  CBTimelineContentView.m
//  sWiBoo
//
//  Created by ly on 10/25/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBTimelineContentView.h"

@implementation CBTimelineContentView

- (void)setText:(NSString *)text andImageWithURL:(NSURL *)URL width:(CGFloat)width
{
    _text = text;
    _width = width;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:URL];
        UIImage *aImage = [[UIImage alloc] initWithData:imageData];
        _image = aImage;
    });
    [self adjustSize];
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
}

-(void)adjustSize
{
    CGFloat fontSize = 13.0f;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
    
    CGSize constrainedSize = CGSizeMake(_width, 100);
    CGSize newSize = [_text sizeWithFont:systemFont constrainedToSize:constrainedSize];
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    self.frame = CGRectMake(x, y, _width, newSize.height);
}

@end
