//
//  CBTimelineContentView.m
//  sWiBoo
//
//  Created by ly on 10/25/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBTimelineContentView.h"

@implementation CBTimelineContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setText:(NSString *)text andImageWithURL:(NSURL *)URL width:(CGFloat)width
{
    _text = text;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:URL];
        UIImage *aImage = [[UIImage alloc] initWithData:imageData];
        _image = aImage;
    });
    _width = width;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGPoint leftTop = CGPointMake(5, 5);
    CGFloat fontSize = 13.0f;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
    [_text drawAtPoint:leftTop forWidth:_width withFont:systemFont fontSize:fontSize lineBreakMode:NSLineBreakByWordWrapping baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
}

@end
