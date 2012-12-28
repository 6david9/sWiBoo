//
//  CBUserDetailViewController.m
//  sWiBoo
//
//  Created by ly on 11/5/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBUserDetailViewController.h"
#import "CBStatusCell.h"
#import "CBUserInfoCell.h"
#import "SinaWeibo.h"
#import "CBAppDelegate.h"
#import "UIImageView+WebCache.h"

@interface CBUserDetailViewController ()

@property (assign, nonatomic) BOOL userInfoLoaded;

- (SinaWeibo *)weibo;
- (void)loadingInfo;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)newCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CBUserDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSAssert(self.userID != nil, @"在视图被加载前，userID必须被正确赋值");
    NSLog(@"%@", self.userID);
    
    self.list = [[CBStatusSet alloc] init];
    [self loadingInfo];
    
}

- (void)viewDidUnload
{
    self.list = nil;
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

- (void)loadingInfo
{
    NSMutableDictionary *params;
    
    // 下载用户信息
    params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:self.userID forKey:@"uid"];
    [self.weibo requestWithURL:@"users/show.json" params:params httpMethod:@"GET" delegate:self];
    params = nil;
    
    // 下载该用户所发微博
    params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setValue:self.userID forKey:@"uid"];
    [params setValue:@"10" forKey:@"count"];
    [self.weibo requestWithURL:@"statuses/user_timeline.json" params:params httpMethod:@"GET" delegate:self];
    params = nil;
    
}

#pragma mark - SinaWeibo Request Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSArray *statuses;
    if ( [request.url rangeOfString:@"users/show.json"].location != NSNotFound ) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.userInfo = [[CBUserInfo alloc] initWithDictionary:result];
            self.userInfoLoaded = YES;
        }
        
    } else if ( [request.url rangeOfString:@"statuses/user_timeline.json"].location != NSNotFound ) {
        if ( [result isKindOfClass:[NSDictionary class]] ) {
            statuses = [result valueForKey:@"statuses"];
           
            [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                CBStatus *status;
                
                status = [[CBStatus alloc] initWithDictionary:obj];
                [self.list addStatus:status];
            }];
            
            // 判断是否获取到新的微博信息
            [self.tableView reloadData];
            
            statuses = nil;
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    count = [self.list count] + (self.userInfoLoaded? 1: 0);
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        CBUserInfoCell *cell = (CBUserInfoCell *)[self newCellForTable:tableView atIndexPath:indexPath];
        return [cell height];
    } else {
        CBStatusCell *cell = (CBStatusCell *)[self newCellForTable:tableView atIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return [cell height];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [self newCellForTable:tableView atIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UITableViewCell *)newCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *UserCellIdentifier = @"UserInfoCell";
    static NSString *statusCellIdentifier = @"statusCellIdentifier";
    
    if (row == 0) {
        
        CBUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
        if (cell == nil)
            cell = [[CBUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:UserCellIdentifier];
        return cell;
    } else {
        
        CBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:statusCellIdentifier];
        if (cell == nil)
            cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:statusCellIdentifier];
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        if (self.userInfoLoaded) {
            CBUserInfoCell *userInfoCell = (CBUserInfoCell *)cell;
            [userInfoCell.avatar setImageWithURL:self.userInfo.avatarURL placeholderImage:[UIImage imageNamed:@"avatar_default_big.png"]];
            userInfoCell.nameLabel.text = self.userInfo.name;
            userInfoCell.weiboCountLabel.text = self.userInfo.weiboCount;
            userInfoCell.followerCountLabel.text = self.userInfo.followerCount;
            userInfoCell.friendsCountLabel.text = self.userInfo.friendsCount;
        }
    } else {
        CBStatusCell *statusCell = (CBStatusCell *)cell;
        CBStatus *status = [self.list objectAtIndex:row-1];     //第0行为用户信息行，status起始行为row-1
        statusCell.statusID = status.statusID;
        statusCell.text = status.text;
        statusCell.imageURL = status.imageURL;
        statusCell.repostText = status.repostText;
        statusCell.repostImageURL = status.repostImageURL;
        statusCell.avatarURL = status.avatarURL;
        statusCell.commentCount = status.commentCount;
        statusCell.repostCount = status.repostCount;
    }
}

@end
