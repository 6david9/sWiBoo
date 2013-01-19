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
#import "SDImageCache.h"

#import "CBStatus.h"

@interface CBHomeViewController ()

//@property (strong, nonatomic) NSMutableOrderedSet *status;
@property (strong, nonatomic) NSString *lastStatusID;

- (void)configureCell:(CBStatusCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)loadingMore;
- (void)compose;

@end

@implementation CBHomeViewController
{
    CBStatusCell *heightCell;
}
@synthesize lastStatusID = _lastStatusID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        @autoreleasepool {
            self.title = NSLocalizedString(@"Home", @"主页");
            self.tabBarItem.image = [UIImage imageNamed:@"navigationbar_home.png"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 行高
    self.tableView.rowHeight = 44;

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
    [[SDImageCache sharedImageCache] clearMemory];
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
    static NSInteger i = 0;
    static NSString *CellIdentifier = @"StatusCellHeight";
    if (heightCell == nil) {
        heightCell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                            reuseIdentifier:CellIdentifier];
        NSLog(@"height reuse cell:%d", ++i);
    }
    
    [self configureCell:heightCell atIndexPath:indexPath];
    
    return [heightCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBStatusCell *cell;
    static NSString *CellIdentifier = @"HomeStatusCell";
    static NSInteger i = 0;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier];
        NSLog(@"cell reuse:%d", i);
    }
    
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
    detailStatusViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailStatusViewController animated:YES];
}


#pragma mark Configure Cell

- (CBStatusCell *)newCellForTable:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"StatusCell";
    CBStatusCell *cell;
    static NSInteger i = 0;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier];
        NSLog(@"%d", ++i);
    }

    return cell;
}

- (void)configureCell:(CBStatusCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row;
    CBStatus *status;
    
    row = indexPath.row;
    status = [self.list objectAtIndex:row];
    
    NSString *repostText = [status.repost_screen_name
                                stringByAppendingFormat:@":%@", status.repostText];
    
    cell.statusID =         status.statusID;
    cell.avatarURL =        status.avatarURL;
    cell.name =             status.screen_name;
    cell.postDate =         status.postDate;
    [cell setText:status.text andImageWithURL:status.imageURL];
    [cell setRepostText:repostText andRepostImageWithURL:status.repostImageURL];
    cell.textFrom =         status.fromText;
    [cell setCommentCount:status.commentCount andRepostCount:status.repostCount];
    cell.containerViewController = self;
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
    NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.list count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:indexPath];
        indexPath = nil;
    }
    
    [self.list removeAllObjects];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPathArray
                          withRowAnimation:UITableViewScrollPositionNone];
    [self.tableView endUpdates];
    
    
    [self loadingMore];
    
    if ([self.list count]>0) {
        [self.tableView scrollsToTop];
    }
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
                [self performSelectorOnMainThread:@selector(addNewStatusToTable:) withObject:[NSNumber numberWithInteger:addCount] waitUntilDone:YES];
                
                self.lastStatusID = [[statuses lastObject] valueForKey:@"idstr"];
                [[SDImageCache sharedImageCache] clearMemory];
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

- (void)addNewStatusToTable:(NSNumber *)addCountNum
{
    @autoreleasepool {
        NSInteger addCount = [addCountNum integerValue];
        NSInteger oldListCount = [self.list count]-addCount;
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < addCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:oldListCount+i inSection:0];
            [indexPathArray addObject:indexPath];
        }
        
        // 插入数据
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        // 清理内存
        [self performSelectorOnMainThread:@selector(deleteOldStatus:) withObject:addCountNum waitUntilDone:YES];
    }
}

- (void)deleteOldStatus:(NSNumber *)addCountNum
{
    NSInteger addCount = [addCountNum integerValue];
    
    if ( ([self.list count]-addCount) >= 20) {
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        // 生成需要删除的indexPath
        for (NSInteger i = 0; i < 20; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0 ];
            [indexPathArray addObject:indexPath];
        }
        
        // 先删除list中数据
        NSRange removeRange = NSMakeRange(0, 20);
        [self.list removeObjectsInRange:removeRange];
        
        // 删除行
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        // 滚动到更新前的最后一行
        NSInteger row = [self.list count] - addCount - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewRowAnimationTop animated:NO];
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
    
    // 停止更新
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = NO;
    self.tableView.pullTableIsLoadingMore = NO;
    
    // 显示错误提示
    NSString *alertString;
    if ([error code] == 10023) {    // User requests out of rate limit!
       alertString = @"用户请求太频繁，请稍后重试！";
    } else {
        alertString = @"未知错误，请稍后重试！";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                           message:alertString
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [alertView show];
   
    
}

@end
