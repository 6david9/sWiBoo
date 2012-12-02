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
#import "CBStatusCell/CBStatusCell.h"

@interface CBHomeViewController ()

@property (strong, nonatomic) UINib *_cellNib;

- (void)configureCell:(CBStatusCell *)cell atIndexPath:(NSIndexPath *)indexpath;
- (void)loadingMore;
- (void)fetch;
- (void)refresh;
- (void)compose;
- (BOOL)weiboIsExist:(NSNumber *)weiboID;

@end

@implementation CBHomeViewController

@synthesize fetchedResultsController = _fetchedResultsController;

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
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = refresh;
    
    // 添加发微博按钮
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem = compose;
    
    // 在视图载入时加载更多
//    [self loadingMore];
    [self fetch];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [NSFetchedResultsController deleteCacheWithName:@"StatusCache"];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSLog(@"%d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBStatusCell *cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatusCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
    return [cell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatusCell";
    CBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /* 跳转到详细页面 */
    CBDetailStatusViewController *detailStatusViewController = [[CBDetailStatusViewController alloc] initWithNibName:@"CBDetailStatusViewController" bundle:nil];
    detailStatusViewController.hidesBottomBarWhenPushed = YES;

    // 为下一页面创建新cell
    CBStatusCell *cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatusCell"];
    [self configureCell:cell atIndexPath:indexPath];
    detailStatusViewController.headCell = cell;
    detailStatusViewController.headCellHeight = [cell height];
    detailStatusViewController.status_idstr = cell.status_idstr;
    [self.navigationController pushViewController:detailStatusViewController animated:YES];
    
    cell = nil;
}


#pragma mark - Configure Cell
- (void)configureCell:(CBStatusCell *)cell atIndexPath:(NSIndexPath *)indexpath
{
    FriendsTimeline *obj = [[self fetchedResultsController] objectAtIndexPath:indexpath];
    UserInfo *user = obj.user;
    
    NSString *statusid = [obj valueForKey:@"status_idstr"];
    NSString *name = [user valueForKey:@"screen_name"];
    NSUInteger numComment = [[obj valueForKey:@"comments_count"] unsignedIntegerValue];
    NSUInteger numRepost = [[obj valueForKey:@"reposts_count"] unsignedIntegerValue];
    
    [cell setStatus_idstr:statusid];
    [cell setName:name];
    [cell setCommentCount:numComment];
    [cell setRepostCount:numRepost];
    
    // 设置头像
    NSURL *avatarURL = [NSURL URLWithString:[user valueForKey:@"profile_image_url"]];
    [cell setAvatarWithURL:avatarURL];

    // 设置正文内容
    NSString *text = [obj valueForKey:@"text"];
    NSURL *repostImageURL = [NSURL URLWithString:[obj valueForKey:@"thumbnail_pic"]];
    [cell setAvatarWithURL:avatarURL];
    [cell setWhatISaid:text repostText:nil andImageWithURL:repostImageURL];
}

#pragma mark - Loading More
- (void)refresh
{
    [self loadingMore];
}

- (void)compose
{
    CBComposeViewController *composeViewController = [[CBComposeViewController alloc] initWithNibName:@"CBComposeViewController" bundle:nil];
    [composeViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:composeViewController animated:YES];
}

- (void)loadingMore
{
    SinaWeibo *weibo = self.weibo;
    
    NSAssert(weibo != nil, @"loadingMore: 属性weibo未赋值");
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setValue:weibo.accessToken forKey:@"access_token"];
    if (lastStatusID != nil) {
        [params setValue:lastStatusID forKey:@"since_id"];
    }
    [weibo requestWithURL:@"statuses/home_timeline.json" params:params httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *statuses = [result valueForKey:@"statuses"];
        
        // 遍历数组，为每条记录生成托管对象
        NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
        
        [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            if (![self weiboIsExist:[obj valueForKey:@"id"]]) {
                // 保存最后条微博的id
                if ([obj isEqual:[statuses lastObject]]) {
                    lastStatusID = [obj valueForKey:@"idstr"];
                }
                
                // 创建托管对象
                FriendsTimeline *statusObject = [NSEntityDescription insertNewObjectForEntityForName:@"FriendsTimeline" inManagedObjectContext:context];
                statusObject.status_id = [obj valueForKey:@"id"];
                statusObject.status_idstr = [obj valueForKey:@"idstr"];
                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:@"EE MMM dd H:mm:ss +z yyy"];
                NSDate *createatDate = [dateFormater dateFromString:[obj valueForKey:@"created_at"]];
                statusObject.created_at = createatDate;
                statusObject.source = [obj valueForKey:@"source"];
                statusObject.text = [obj valueForKey:@"text"];
                statusObject.favorited = [obj valueForKey:@"favorited"];
                statusObject.truncated = [obj valueForKey:@"truncated"];
                statusObject.comments_count = [obj valueForKey:@"comments_count"];
                statusObject.reposts_count = [obj valueForKey:@"reposts_count"];
                statusObject.thumbnail_pic = [obj valueForKey:@"thumbnail_pic"];
                statusObject.bmiddle_pic = [obj valueForKey:@"bmiddle_pic"];
                statusObject.original_pic = [obj valueForKey:@"original_pic"];
                
                UserInfo *userObject = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
                NSDictionary *user = [obj valueForKey:@"user"];
                userObject.user_id = [user valueForKey:@"id"];
                userObject.screen_name = [user valueForKey:@"screen_name"];
                userObject.profile_image_url = [user valueForKey:@"profile_image_url"];
                userObject.status = statusObject;
                statusObject.user = userObject;
            }
        }];
        
        // 保存context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"保存获取的friends time line 出错: %@", error);
        }
        
        [self fetch];
    }
}

- (BOOL)weiboIsExist:(NSNumber *)weiboID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *timelineEntity = [NSEntityDescription entityForName:@"FriendsTimeline" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:timelineEntity];
    
    NSSortDescriptor *tsortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [request setSortDescriptors:@[tsortDescriptor]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status_id == %@", weiboID];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray * results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil)
        NSLog(@"error: %@", error);
    
    else if ([results count] > 0)
        return YES;
    
    return NO;
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}


#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSAssert(self.managedObjectContext != nil, @"self.managedObjectContext 未正常初始化");
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"FriendsTimeline" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        [request setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"StatusCache"];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self.tableView reloadData];
    [self.tableView scrollsToTop];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(CBStatusCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }

}

-(void)fetch
{
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
        NSLog(@"fetch error: %@", error);
    NSLog(@"fetch");
}

@end
