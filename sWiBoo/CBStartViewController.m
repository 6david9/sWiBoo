//
//  CBStartViewController.m
//  sWiBoo
//
//  Created by ly on 10/24/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStartViewController.h"

#import "CBAppDelegate.h"
#import "CBHomeViewController.h"
#import "CBMoreViewController.h"


@interface CBStartViewController ()

- (void)successLogin;

@end

@implementation CBStartViewController

@synthesize weibo = _weibo;

@synthesize managedObjectContext = _managedObjectContext;

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
    
    if ([[self weibo] isAuthValid]) 
        [self successLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Method
- (IBAction)login:(id)sender
{
    [[self weibo] logIn];
}

#pragma mark - Private Method
- (void)successLogin
{
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    
    CBHomeViewController *homeViewController = [[CBHomeViewController alloc] initWithNibName:@"CBHomeViewController" bundle:nil];
    homeViewController.managedObjectContext = self.managedObjectContext;
    homeViewController.weibo = self.weibo;
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    CBMoreViewController *moreViewController = [[CBMoreViewController alloc] initWithNibName:@"CBMoreViewController" bundle:nil];
    
    tabbarController.viewControllers = @[homeNavi, moreViewController];
    [self addChildViewController:tabbarController];
    [self.view addSubview:tabbarController.view];
}

#pragma mark - Sina Weibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // 保存登录信息
    NSAssert(self.appDelegate != nil, @"self.appDelegate不能为nil");
    CBAppDelegate *appDelegate = self.appDelegate;
    if (appDelegate != nil)
        [appDelegate saveWeibo];
    
    [self successLogin];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

@end
