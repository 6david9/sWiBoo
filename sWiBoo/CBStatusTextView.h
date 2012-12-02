//
//  CBStatusTextView.h
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBStatusTextView : UIView

@property (strong, nonatomic) UILabel *textContentLabel;
@property (strong, nonatomic) UIImageView *imageContentView;

- (CGSize)neededSize;

@end
