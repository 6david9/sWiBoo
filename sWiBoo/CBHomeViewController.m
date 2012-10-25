//
//  CBHomeViewController.m
//  sWiBoo
//
//  Created by ly on 10/24/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBHomeViewController.h"

#import "CBTimelineCell.h"
#import "FriendsTimeline.h"
#import "UserInfo.h"

@interface CBHomeViewController ()

@property (strong, nonatomic) UINib *cellNib;

- (void)configureCell:(CBTimelineCell *)cell atIndexPath:(NSIndexPath *)indexpath;
- (void)loadingMore;
- (void)fetch;
- (BOOL)weiboIsExist:(NSNumber *)weiboID;

@end

@implementation CBHomeViewController

@synthesize cellNib = _cellNib;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"主页");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _cellNib = [UINib nibWithNibName:@"CBTimelineCell" bundle:nil];
    
    [self loadingMore];
    [self fetch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTmpCell:nil];
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
    return [sectionInfo numberOfObjects];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CBTimelineCell *cell = (CBTimelineCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSUInteger height = cell.bounds.size.height;
//    
//    return height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimelineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
//        [self.cellNib instantiateWithOwner:self options:nil];
//        cell = [self.tmpCell copy];
//        self.tmpCell = nil;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - Configure Cell
- (void)configureCell:(CBTimelineCell *)cell atIndexPath:(NSIndexPath *)indexpath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSManagedObject *obj = [[self fetchedResultsController] objectAtIndexPath:indexpath];
    cell.textLabel.text = [obj valueForKey:@"text"];
    
//    cell.name = [obj valueForKey:@"screen_name"];
//    cell.numComment = [[obj valueForKey:@"comments_count"] integerValue];
//    cell.numRetweet = [[obj valueForKey:@"reposts_count"] integerValue];
    
//    NSURL *avatarURL = [NSURL URLWithString:[obj valueForKey:@"profile_image_url"]];
//    [cell setAvatarWithURL:avatarURL];
//    
//    NSString *content = [obj valueForKey:@"text"];
//    NSURL *imageURL = [NSURL URLWithString:[obj valueForKey:@"bmiddle_pic"]];
//    [cell setContent:content andImageWithURL:imageURL];
}

#pragma mark - Loading More
- (void)loadingMore
{
    SinaWeibo *weibo = self.weibo;
    
    NSAssert(weibo != nil, @"loadingMore: 属性weibo未赋值");
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:weibo.accessToken forKey:@"access_token"];
    [weibo requestWithURL:@"statuses/friends_timeline.json" params:params httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSArray *statuses = [result valueForKey:@"statuses"];
        
        // 遍历数组，为每条记录生成托管对象
        NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
        
        [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            if (![self weiboIsExist:[obj valueForKey:@"id"]]) {
                
                FriendsTimeline *statusObject = [NSEntityDescription insertNewObjectForEntityForName:@"FriendsTimeline" inManagedObjectContext:context];
                statusObject.status_id = [obj valueForKey:@"id"];
                statusObject.status_idstr = [obj valueForKey:@"idstr"];
                statusObject.created_at = [obj valueForKey:@"created_at"];
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FriendsTimeline" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status_id == %@", weiboID];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray * results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    NSLog(@"%d", [results count]);
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
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Status"];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"fetch");
}



@end
