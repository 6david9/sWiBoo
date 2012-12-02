//
//  CBStatusContentView.h
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStatusTextView.h"

@interface CBStatusContentView : UIView

@property (strong, nonatomic) CBStatusTextView  *textView;
@property (strong, nonatomic) CBStatusTextView  *retweetView;

- (void)setText:(NSString *)text;
- (void)setImage:(UIImage *)image;
- (void)setRetweetedText:(NSString *)retweetedText;
- (void)setRetweetedImage:(UIImage *)retweetedImage;

- (void)reset;

- (CGSize)neededSize;

@end
