//
//  CBStatusContentView.h
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStatusTextView.h"
#import "SDWebImageManagerDelegate.h"

@interface CBStatusContentView : UIView <SDWebImageManagerDelegate>

@property (nonatomic, strong) CBStatusTextView *statusView;
@property (nonatomic, strong) CBStatusTextView *repostStatusView;

- (void)addText:(NSString *)text;
- (void)addImage:(UIImage *)image;
- (void)addimageWithURL:(NSURL *)imageURL;
- (void)addrepostText:(NSString *)repostText;
- (void)addRepostImage:(UIImage *)repostImage;
- (void)addRepostImageURL:(NSURL *)repostImageURL;

- (CGFloat)height;

@end
