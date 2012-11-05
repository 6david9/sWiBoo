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
#import "CBFollowerViewController.h"


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
    self.mainTabbarController = [[UITabBarController alloc] init];
    
    CBHomeViewController *homeViewController = [[CBHomeViewController alloc] initWithNibName:@"CBHomeViewController" bundle:nil];
    homeViewController.managedObjectContext = self.managedObjectContext;
    homeViewController.weibo = self.weibo;
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    CBFollowerViewController *followerViewController = [[CBFollowerViewController alloc] initWithNibName:@"CBFollowerViewController" bundle:nil];
    UINavigationController *userDetailNavigationController = [[UINavigationController alloc] initWithRootViewController:followerViewController];
    
    CBMoreViewController *moreViewController = [[CBMoreViewController alloc] initWithNibName:@"CBMoreViewController" bundle:nil];
    
    self.mainTabbarController.viewControllers = @[homeNavi, userDetailNavigationController, moreViewController];
    [self addChildViewController:self.mainTabbarController];
    [self.view addSubview:self.mainTabbarController.view];
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
    
    if ([self.weibo isAuthValid])
        [self successLogin];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weibo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.mainTabbarController removeFromParentViewController];
    // !!!!!!!!!!!!由于网络缓存问题，不能立即退出 !!!!!!!!!!!!!!!!!
    // 解决办法：
    //          在授权验证请求中添加 forcelogin=true
    //          删除http cookie
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
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
