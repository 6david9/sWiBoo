//
//  CBHomeViewController.m
//  sWiBoo
//
//  Created by ly on 10/24/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBHomeViewController.h"
#import "CBComposeViewController.h"
#import "FriendsTimeline.h"
#import "UserInfo.h"
#import "CBDetailStatusViewController.h"
#import "CBStatusCell.h"
#import "SinaWeibo.h"

#import "CBStatus.h"

@interface CBHomeViewController ()

//@property (strong, nonatomic) NSMutableOrderedSet *status;
@property (strong, nonatomic) NSString *lastStatusID;

- (void)configureCell:(CBStatusCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)loadingMore;
- (void)compose;

@end

@implementation CBHomeViewController

@synthesize fetchedResultsController = _fetchedResultsController;
//@synthesize status = _status;
@synthesize lastStatusID = _lastStatusID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"主页");
        self.tabBarItem.image = [UIImage imageNamed:@"navigationbar_home.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 添加刷新按钮
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
    self.navigationItem.leftBarButtonItem = refresh;
    
    // 添加发微博按钮
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem = compose;
    
    // 创建保存微博记录列表
    self.list = [[CBStatusSet alloc] init];
    
    // 设置pullTableView
    self.tableView.pullDelegate = self;
    self.tableView.pullBackgroundColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    self.list = nil;
    [super viewDidUnload];
}

#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBStatusCell *cell;
    
    cell = [self newCellForTalble:tableView];
    [self configureCell:cell atIndexPath:indexPath];
    
    return [cell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBStatusCell *cell;
    
    cell = [self newCellForTalble:tableView];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    // 取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 显示详细页面
    CBDetailStatusViewController *detailStatusViewController = [[CBDetailStatusViewController alloc] initWithNibName:@"CBDetailStatusViewController" bundle:nil];
    detailStatusViewController.status = [self.list objectAtIndex:row];
    [self.navigationController pushViewController:detailStatusViewController animated:YES];
}


#pragma mark Configure Cell

- (CBStatusCell *)newCellForTalble:(UITableView *)tableView
{
    static NSString *CellIdentifier;
    CBStatusCell *cell;
    
    CellIdentifier = @"StatusCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    return cell;
}

- (void)configureCell:(CBStatusCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row;
    CBStatus *status;
    
    row = indexPath.row;
    status = [self.list objectAtIndex:row];
    
    
    cell.statusID =         status.statusID;
    cell.text =             [status.screen_name stringByAppendingFormat:@": %@", status.text];
    cell.imageURL =         status.imageURL;
    cell.repostText =       [status.repost_screen_name stringByAppendingFormat:@": %@", status.repostText];
    cell.repostImageURL =   status.repostImageURL;
    cell.avatarURL =        status.avatarURL;
    cell.commentCount =     status.commentCount;
    cell.repostCount =      status.repostCount;
}

#pragma mark - PullTableView Delegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
//    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0];
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    [self performSelectorOnMainThread:@selector(loadMoreDataToTable) withObject:nil waitUntilDone:NO];
}

- (void)refreshTable
{
    [self.list removeAllObjects];
    [self loadingMore];
}

- (void)loadMoreDataToTable
{
    [self loadingMore];
}


#pragma mark - Loading More
- (void)compose
{
    CBComposeViewController *composeViewController = [[CBComposeViewController alloc] initWithNibName:@"CBComposeViewController" bundle:nil];
    [composeViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:composeViewController animated:YES];
}

- (void)loadingMore
{
    NSMutableDictionary *params;
    
    if ( [self.weibo isLoggedIn] ) {
        params = [[NSMutableDictionary alloc] initWithCapacity:3];
        
        [params setValue:[self.weibo accessToken] forKey:@"access_token"];
        [params setValue:@"10" forKey:@"count"];
        if (self.lastStatusID != nil)
            [params setValue:self.lastStatusID forKey:@"max_id"];
        
        [self.weibo requestWithURL:@"statuses/home_timeline.json" params:params httpMethod:@"GET" delegate:self];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSArray *statuses;
    NSInteger __block addCount = 0;
    
    if ([request.url rangeOfString:@"home_timeline.json"].location != NSNotFound) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            statuses = [result valueForKey:@"statuses"];
            [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                CBStatus *status;
                
                status = [[CBStatus alloc] initWithDictionary:obj];
                addCount += ([self.list addStatus:status]? 1:0);
            }];
            
            // 判断是否获取到新的微博信息
            if (addCount != 0) {
                [self.tableView reloadData];
                self.lastStatusID = [[statuses lastObject] valueForKey:@"idstr"];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"刷新微博" message:@"没有新微博" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alertView show];
                alertView = nil;
            }
            
            statuses = nil;
            self.tableView.pullLastRefreshDate = [NSDate date];
            self.tableView.pullTableIsRefreshing = NO;
            self.tableView.pullTableIsLoadingMore = NO;
        }
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

@end
