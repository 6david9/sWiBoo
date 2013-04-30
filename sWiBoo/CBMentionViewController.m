//
//  CBMentionViewController.m
//  sWiBoo
//
//  Created by ly on 13-2-20.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import "CBMentionViewController.h"
#import "CBAppDelegate.h"
#import "SinaWeibo.h"
#import "CBFollower.h"

@interface CBMentionViewController ()

@property (strong, nonatomic, readonly) SinaWeibo *weibo;

@end

@implementation CBMentionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.activityIndicator startAnimating];
    
    // 开始加载好友
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.weibo.userID forKey:@"uid"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.weibo requestWithURL:@"friendships/friends/bilateral.json" params:params
                            httpMethod:@"GET" delegate:self];
        });
        params = nil;
    });
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.activityIndicator = nil;
    self.list = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Sina Weibo
- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

#pragma mark - Dismiss Controller 
- (IBAction)dismissController:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    CBFollower *follower = [self.list objectAtIndex:indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@(%@)",follower.screen_name, follower.uid];
    cell.textLabel.text = str;
    follower = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.delegate!=nil && [self.delegate conformsToProtocol:@protocol(CBMentionDelgate)]) {
        if ([self.delegate respondsToSelector:@selector(userDidSelectFollower:)]) {
            // tell him which follower is selected
            CBFollower *follower = [self.list objectAtIndex:indexPath.row];
            [self.delegate userDidSelectFollower:follower];
            follower = nil;

            // 隐藏当前控制器
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}


#pragma mark - Sina weibo delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [self.activityIndicator stopAnimating];
    
    NSArray *users = [result valueForKey:@"users"];
    
    if ([users isKindOfClass:[NSArray class]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *followers = [[NSMutableArray alloc] initWithCapacity:[users count]];
            for (NSInteger i =0 ; i < [users count]; i++) {
                @autoreleasepool {
                    CBFollower *follower = [[CBFollower alloc] initWithDictionary:users[i]];
                    [followers addObject:follower];
                }
            }
            
            // 在主线程更新table
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.list addObjectsFromArray:followers];
                [self.tableView reloadData];

                NSLog(@"%d", [self.list count]);
            });
            followers = nil;
        });
    }
}
@end
