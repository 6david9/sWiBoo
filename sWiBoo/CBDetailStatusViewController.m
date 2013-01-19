//
//  CBDetailStatusViewController.m
//  sWiBoo
//
//  Created by ly on 11/1/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBDetailStatusViewController.h"
#import "CBStatusCell.h"
#import "CBAppDelegate.h"
#import "SinaWeibo.h"
#import "CBStatus.h"
#import "CBComment.h"
#import "UIImageView+WebCache.h"
#import "CBCommentCell.h"

@interface CBDetailStatusViewController ()

@property (assign, nonatomic) CGFloat originalHeight;

- (SinaWeibo *)weibo;
- (void)loadingComment;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath;
- (UITableViewCell *)newCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation CBDetailStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 视图的默认高度
    CGFloat navigationBarHeight = 44.0;
    self.originalHeight = [[UIScreen mainScreen] applicationFrame].size.height-navigationBarHeight;
    self.tableView.rowHeight = 44;
    
    // 监视键盘显示或隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContainerSize:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContainerSize:) name:UIKeyboardWillHideNotification object:nil];
    
    // 添加转发按钮
    UIBarButtonItem *repostItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Repost", @"repost baf button item") style:UIBarButtonItemStyleBordered target:self action:@selector(repost)];
    self.navigationItem.rightBarButtonItem = repostItem;
    
    NSAssert(self.status != nil, @"status属性必须在页面加载前被赋值");
    self.list = [[CBCommentSet alloc] init];
    
    [self loadingComment];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    self.tableView = nil;
    self.status = nil;
    self.list = nil;
    [self setContainerView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)repost
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.status.statusID forKey:@"id"];
    [[self weibo] requestWithURL:@"statuses/repost.json" params:params httpMethod:@"POST" delegate:self];
}

- (void)loadingComment
{
    NSMutableDictionary *params;
    
    params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setValue:self.status.statusID forKey:@"id"];
    [params setValue:@"10" forKey:@"count"];
    [[self weibo] requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
    params = nil;
}

- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url rangeOfString:@"comments/show.json"].location != NSNotFound)
    {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *comments = [result valueForKey:@"comments"];
            
            [comments enumerateObjectsUsingBlock:^(id eachObj, NSUInteger idx, BOOL *stop){
                CBComment *comment = [[CBComment alloc] initWithDictionary:eachObj];
                [self.list addComment:comment];
            }];
            [self.tableView reloadData];
        }
    }
    else if ([request.url rangeOfString:@"statuses/repost.json"].location != NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"转发成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([request.url rangeOfString:@"comments/create.json"].location != NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"评论成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Keyboard Hide Or Show
- (void)adjustContainerSize:(NSDictionary *)notification
{
    // 保存变化前的frame的大小
    __block CGRect aFrame = self.containerView.frame;
    
    NSString *notificationName = [notification valueForKey:@"name"];
    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    
    CGRect keyboardFrame = [[userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [[userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    // 计算更改后的container的frame
    if ([notificationName isEqualToString:UIKeyboardWillShowNotification])
        aFrame.size.height = self.originalHeight - keyboardFrame.size.height;
    else
        aFrame.size.height = self.originalHeight;
    
    // 动画效果，更改container的frame
    [UIView animateWithDuration:duration animations:^{
        self.containerView.frame = aFrame;
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.list count] + 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        CBStatusCell *cell = (CBStatusCell *)[self newCellForTableView:tableView atIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return [cell height];
    }
    else if ([self.list count] == 0) {
        return 44;
    }
    else {
        CBCommentCell *commentCell = [[CBCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCellHeight"];
        [self configureCell:commentCell atIndexPath:indexPath];
        CGFloat height = [commentCell height];
        commentCell = nil;

        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self newCellForTableView:tableView atIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UITableViewCell *)newCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        static NSString *CellIdentifier = @"StatusCell";
        CBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            cell = [[CBStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        return cell;
    } else {
        static NSString *CellIdentifier = @"CommentCell";
        CBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
            cell = [[CBCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath
{
    NSInteger row = indexpath.row;
    
    if (row == 0) {
        CBStatusCell *statusCell = (CBStatusCell *)cell;
        
        NSString *repostText = [self.status.repost_screen_name
                                    stringByAppendingFormat:@":%@", self.status.repostText];
        
        statusCell.statusID =       self.status.statusID;
        statusCell.avatarURL =      self.status.avatarURL;
        statusCell.name = self.status.screen_name;
        statusCell.postDate = self.status.postDate;
        [statusCell setText:self.status.text andImageWithURL:self.status.imageURL];
        [statusCell setRepostText:repostText andRepostImageWithURL:self.status.repostImageURL];
        statusCell.textFrom = self.status.fromText;
        [statusCell setCommentCount:self.status.commentCount andRepostCount:self.status.repostCount];
        statusCell.containerViewController = self;
        
        statusCell.bigImageURL = self.status.bigImageURL;
        statusCell.bigRepostImageURL = self.status.bigRepostImageURL;
    } else {
        CBComment *comment = [self.list objectAtIndex:row-1];
        
        CBCommentCell *commentCell = (CBCommentCell *)cell;
        [commentCell setName:comment.userName];
        [commentCell setCommentText:comment.text];
    }
    
    cell.clipsToBounds = YES;
}
- (IBAction)hideKeyboard:(id)sender
{
    UITextField *textfiled = (UITextField *)sender;
    [textfiled resignFirstResponder];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    [params setValue:[textfiled text] forKey:@"comment"];
    [params setValue:self.status.statusID forKey:@"id"];
    [[self weibo] requestWithURL:@"comments/create.json" params:params httpMethod:@"POST" delegate:self];
    
    textfiled.text = @"";
}

@end
