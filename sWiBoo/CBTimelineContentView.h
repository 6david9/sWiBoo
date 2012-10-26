//
//  CBTimelineContentView.h
//  sWiBoo
//
//  Created by ly on 10/25/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTimelineContentView : UIView
{
    NSString *_text;
    UIImageView *_imageView;
    CGFloat _width;
    BOOL _hasImage;
}

@property (nonatomic, assign) CGFloat textHeight;

- (void)setText:(NSString *)text andImageWithURL:(NSURL *)URL width:(CGFloat)width;
- (void)resetContent;

@end
