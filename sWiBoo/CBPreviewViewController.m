//
//  CBPreviewViewController.m
//  CBStatusCell
//
//  Created by ly on 1/8/13.
//  Copyright (c) 2013 Lei Yan. All rights reserved.
//

#import "CBPreviewViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface CBPreviewViewController ()

@end

@implementation CBPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator startAnimating];
            });
            
            NSData *imageDate = [NSData dataWithContentsOfURL:self.imageURL];
            UIImage *image = [UIImage imageWithData:imageDate];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
                [self.activityIndicator stopAnimating];
                self.saveButton.hidden = NO;
            });
            imageDate = nil;
            image = nil;
        }
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.imageView cancelCurrentImageLoad];
}

- (IBAction)handTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismissModalViewControllerAnimated:NO];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissModalViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [self setActivityIndicator:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (IBAction)saveImage:(id)sender
{
    UIImage *image = self.imageView.image;
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image, self,
            @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    NSString *alertStr;
    if (error == nil) {
        alertStr = @"保存成功";
    } else {
        alertStr = @"保存失败";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
