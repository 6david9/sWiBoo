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

@interface CBDetailStatusViewController ()

@end

@implementation CBDetailStatusViewController

@synthesize headCell = _headCell;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)repost
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
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

@end
