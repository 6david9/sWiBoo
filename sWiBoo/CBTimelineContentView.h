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
    UIImage *_image;
    CGFloat _width;
}

- (void)setText:(NSString *)text andImageWithURL:(NSURL *)URL width:(CGFloat)width;

@end
