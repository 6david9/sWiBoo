//
//  UIView+CBResizeView.m
//  CBStatusCell
//
//  Created by ly on 11/17/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "UIView+CBResizeView.h"

@implementation UIView (CBResizeView)

+ (void)resizeView:(UIView *)view withNewSize:(CGSize)newSize
{
    CGRect viewFrame = view.frame;
    viewFrame.size = newSize;
    view.frame = viewFrame;
}

@end
