//
//  CBStatusTextView.h
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBStatusTextView : UIView
{
//    UIImage __strong *_image;
}

@property (nonatomic, weak) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) UIImage *backgroudImage;

//@property (atomic, weak) UIImage *img;

- (void)setImageWithURL:(NSURL *)url;
- (CGFloat)height;

@end
