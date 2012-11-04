//
//  CBDetailStatusViewController.m
//  sWiBoo
//
//  Created by ly on 11/1/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBDetailStatusViewController.h"
#import "CBTimelineCell.h"
#import "CBDetailStatusContentViewController.h"
#import "CBAppDelegate.h"
#import "Comment.h"

@interface CBDetailStatusViewController ()

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath;
- (void)loadingMore;

@end

@implementation CBDetailStatusViewController

@synthesize headCell = _headCell;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

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
    NSAssert(self.headCell != nil, @"headCell不能为nil");
    NSAssert(self.headCellHeight > 0, @"headCellHeight未赋值");
    
    NSLog(@"status idstr:%@", self.headCell.status_idstr);
    NSLog(@"name: %@", self.headCell.name);
    
    // 在导航栏右侧添加转发按钮
    UIImage *repostItemImage = [UIImage imageNamed:@"timeline_retweet_count_icon.png"];
    UIBarButtonItem *repostItem = [[UIBarButtonItem alloc] initWithImage:repostItemImage style:UIBarButtonItemStylePlain target:self action:@selector(repost)];
    self.navigationItem.rightBarButtonItem = repostItem;
    
    // 加载评论
    [self loadingMore];
    
    [self fetch];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSFetchedResultsController deleteCacheWithName:@"CommentCache"];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [NSFetchedResultsController deleteCacheWithName:@"CommentCache"];
}

- (void)repost
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSLog(@"table rows: %d", [sectionInfo numberOfObjects]);
    NSUInteger numComment = [sectionInfo numberOfObjects];
    return numComment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return self.headCellHeight;
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return (UITableViewCell *)self.headCell;
    }
    
    static NSString *CellIdentifier = @"CommentCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return nil;
        
    return indexPath;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath
{
//    cell.textLabel.text = @"title";
//    cell.detailTextLabel.text = @"subtitle";
    Comment *comment = [[self fetchedResultsController] objectAtIndexPath:indexpath];
    cell.textLabel.text = [comment valueForKey:@"user_name"];
    cell.detailTextLabel.text = [comment valueForKey:@"text"];
}

- (void)loadingMore
{
    NSAssert(self.weibo != nil, @"未成功获取微博引用，%s, %d", __FILE__, __LINE__);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:4];
    [params setValue:self.weibo.accessToken forKey:@"access_token"];
    [params setValue:@"10" forKey:@"count"];
    [params setValue:self.status_idstr forKey:@"id"];
    if (self.lastCommentID != nil) {
        [params setValue:self.lastCommentID forKey:@"since_id"];
    }
    [self.weibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
}

#pragma mark - weibo delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"无法显示评论信息: %@", error);
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result;
{
    NSLog(@"接收到微博评论列表");
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        // 处理结果
        NSArray *comments = [result valueForKey:@"comments"];
        
        NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
        
        [comments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            if (![self existComment:[obj valueForKey:@"idstr"]]) {
                
                Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:context];
                
                comment.comment_id = [obj valueForKey:@"idstr"];
                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:@"EE MMM dd H:mm:ss +z yyy"];
                NSDate *createatDate = [dateFormater dateFromString:[obj valueForKey:@"created_at"]];
                comment.created_at = createatDate;
                
                comment.text = [obj valueForKey:@"text"];
                comment.source = [obj valueForKey:@"source"];
                comment.user_name = [[obj valueForKey:@"user"] valueForKey:@"screen_name"];
                
                comment.status_id = [[obj valueForKey:@"status"] valueForKey:@"idstr"];
            }

        }];
        
        // 保存context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"保存获取的friends time line 出错: %@", error);
        } else {
            [self fetch];
        }
        
        
    } else {
        NSLog(@"评论信息格式不正确! file:%s, line:%d", __FILE__, __LINE__);
        NSLog(@"%@", [result class]);
    }
}

- (BOOL)existComment:(NSNumber *)commentID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *commentEntity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:commentEntity];
    
    NSSortDescriptor *tsortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [request setSortDescriptors:@[tsortDescriptor]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"comment_id==%@", commentID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray * results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil)
        NSLog(@"error: %@", error);
    
    else if ([results count] > 0)
        return YES;
    
    return NO;
}

#pragma mark - Core data
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil)
        _managedObjectContext = [(CBAppDelegate *)[[UIApplication sharedApplication] delegate]
                                    managedObjectContext];

    return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSAssert(self.managedObjectContext != nil, @"self.managedObjectContext 未正常初始化");
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status_id==%@", self.status_idstr];
        [request setPredicate:predicate];
        
        [request setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"CommentCache"];
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
//    [self.tableView reloadData];
//    [self.tableView scrollsToTop];
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
            [self configureCell:(CBTimelineCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
    else {
        NSLog(@"fetch success");
//        [self.tableView reloadData];
//        NSLog(@"fetched objects:\n%@", [self.fetchedResultsController fetchedObjects]);
    }
}

@end
