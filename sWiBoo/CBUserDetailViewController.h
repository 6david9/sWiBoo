//
//  CBUserDetailViewController.h
//  sWiBoo
//
//  Created by ly on 11/5/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBStatusCell;
@interface CBUserDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) CBStatusCell *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
