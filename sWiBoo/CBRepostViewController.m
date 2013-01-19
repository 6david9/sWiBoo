//
//  CBRepostViewController.m
//  sWiBoo
//
//  Created by ly on 1/19/13.
//  Copyright (c) 2013 Lei Yan. All rights reserved.
//

#import "CBRepostViewController.h"
#import "CBAppDelegate.h"
#import "SinaWeibo.h"

@interface CBRepostViewController ()

@end

@implementation CBRepostViewController

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
    
    UIBarButtonItem *repostItem = [[UIBarButtonItem alloc] initWithTitle:@"Repost" style:UIBarButtonItemStyleBordered target:self action:@selector(repost)];
    self.navigationItem.rightBarButtonItem = repostItem;
    
    [self.textView becomeFirstResponder];
}

- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

- (void)repost
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *text = self.textView.text;
    if ( text != nil) {
        if ([text length]<=140) {
            [params setValue:text forKey:@"status"];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"发送文字不能超过140个字" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    [params setValue:self.statusId forKey:@"id"];
    [[self weibo] requestWithURL:@"statuses/repost.json" params:params httpMethod:@"POST" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"转发失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"转发成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
