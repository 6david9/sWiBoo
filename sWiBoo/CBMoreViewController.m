//
//  CBMoreViewController.m
//  sWiBoo
//
//  Created by ly on 10/24/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBMoreViewController.h"
#import "CBAppDelegate.h"
#import "SinaWeibo.h"

@interface CBMoreViewController ()

@end

@implementation CBMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"More", @"更多");
        self.tabBarItem.image = [UIImage imageNamed:@"navigationbar_more_highlighted.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CBAppDelegate *)appDelegate
{
    return (CBAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)logout:(id)sender
{
    [[[self appDelegate] weibo] logOut];
    [[self appDelegate] logoutWeibo];
//    [self.tabBarController.view removeFromSuperview];
    [self dismissModalViewControllerAnimated:YES];
}
@end
