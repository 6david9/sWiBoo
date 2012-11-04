//
//  CBEmotionView.m
//  sWiBoo
//
//  Created by ly on 10/28/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBEmotionView.h"

#define kEmotionWidth   35
#define kEmotionHeight  35

@implementation CBEmotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = YES;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        self.contentSize = CGSizeMake(320, 595);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSUInteger numPerLine = (NSUInteger)(320 / kEmotionWidth);
    NSUInteger columPosition = 0;
    NSUInteger rowPosition = 0;
    
    for (NSUInteger i = 0; i < 146; i++) {
        @autoreleasepool {
            columPosition = i % numPerLine;
            
            if (columPosition == 0 && i > columPosition)
                rowPosition += 1;
            
            NSString *emotionName = [NSString stringWithFormat:@"%03d.gif", i+1];
            NSData *emotionData = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:emotionName]];
            
            CGFloat x = columPosition * kEmotionWidth;
            CGFloat y = rowPosition * kEmotionHeight;
            CGRect gifFrame = CGRectMake(x, y, 35, 35);
            UIWebView *gifShower = [[UIWebView alloc] initWithFrame:gifFrame];
            
            [gifShower.scrollView setMinimumZoomScale:0.1];
            if ((i+1) <=104)
                [gifShower.scrollView setZoomScale:0.58];
            
            gifShower.userInteractionEnabled = NO;
            gifShower.scrollView.contentSize = CGSizeMake(35, 35);
            [gifShower loadData:emotionData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            
            [self addSubview:gifShower];
        }
    }

}


@end
