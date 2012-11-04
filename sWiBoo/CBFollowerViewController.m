//
//  CBFollowerViewController.m
//  sWiBoo
//
//  Created by ly on 11/4/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBFollowerViewController.h"
#import "CBAppDelegate.h"
#import "CBFollowerCell.h"
#import "Follower.h"
#import "UIImageView+AsynImage.h"

@interface CBFollowerViewController ()

- (SinaWeibo *)weibo;
- (void)loadingMore;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath;
- (BOOL)existUser:(NSNumber *)userID;

@end

@implementation CBFollowerViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Followers", @"粉丝");
        self.tabBarItem.image = [UIImage imageNamed:@"poi_no_people.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cellNib = [UINib nibWithNibName:@"CBFollowerCell" bundle:nil];
    
    [self loadingMore];
    [self fetch];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSFetchedResultsController deleteCacheWithName:@"FollowerCache"];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTmpCell:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view
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
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FollowerCell";
    CBFollowerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [self.cellNib instantiateWithOwner:self options:nil];
        cell = self.tmpCell;
        self.tmpCell = nil;
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)configureCell:(CBFollowerCell *)cell atIndexPath:(NSIndexPath *)indexpath
{
//    cell.name.text = @"new name";
    Follower *follower = [[self fetchedResultsController] objectAtIndexPath:indexpath];
    NSURL *imageURL = [NSURL URLWithString:follower.profile_image_url];
   
    cell.name.text = follower.screen_name;
    [cell.avatarView setImageWithURL:imageURL];
    if (follower.follow_me) {
        [cell.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    } else {
        [cell.followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
}

#pragma mark - Weibo request
- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

- (void)loadingMore
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.weibo.accessToken forKey:@"access_token"];
    [params setValue:self.weibo.userID forKey:@"uid"];
    [self.weibo requestWithURL:@"friendships/followers.json"
                        params:params
                    httpMethod:@"GET"
                      delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@\n%d: %s", error, __LINE__, __FILE__);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", result);
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        NSArray *users = [result valueForKey:@"users"];
        NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
        
        [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            if (![self existUser:[obj valueForKey:@"idstr"]]) {
                Follower *follower = [NSEntityDescription insertNewObjectForEntityForName:@"Follower" inManagedObjectContext:context];
                follower.idstr = [obj valueForKey:@"idstr"];
                follower.screen_name = [obj valueForKey:@"screen_name"];
                follower.profile_image_url = [obj valueForKey:@"profile_image_url"];
                follower.gender = [obj valueForKey:@"gender"];
                follower.follow_me = [obj valueForKey:@"follow_me"];
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
        NSLog(@"%d: %s\n返回结果文件格式不正确", __LINE__, __FILE__);
    }
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Follower" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        
        [request setFetchBatchSize:20];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"screen_name" ascending:NO];
        [request setSortDescriptors:@[sortDescriptor]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"FollowerCache"];
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
            [self configureCell:(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    } 
}

- (BOOL)existUser:(NSNumber *)userID
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *commentEntity = [NSEntityDescription entityForName:@"Follower" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:commentEntity];
    
    NSSortDescriptor *tsortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"screen_name" ascending:NO];
    [request setSortDescriptors:@[tsortDescriptor]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idstr==%@", userID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray * results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil)
        NSLog(@"error: %@", error);
    
    else if ([results count] > 0)
        return YES;
    
    return NO;
}

-(void)fetch
{
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
        NSLog(@"fetch error: %@", error);
    else {
        NSLog(@"fetch success");
    }
}


@end
