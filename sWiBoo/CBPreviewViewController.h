//
//  CBPreviewViewController.h
//  CBStatusCell
//
//  Created by ly on 1/8/13.
//  Copyright (c) 2013 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPreviewViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *imageURL;
@property (weak, nonatomic) UIViewController *containerController;

- (IBAction)saveImage:(id)sender;

@end
