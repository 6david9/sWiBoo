//
//  CBUserDetailViewController.h
//  sWiBoo
//
//  Created by ly on 11/5/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStatusSet.h"
#import "CBUserInfo.h"

@class CBStatusCell;
@interface CBUserDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,SinaWeiboRequestDelegate>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) CBStatusCell *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CBStatusSet *list;
@property (strong, nonatomic) CBUserInfo *userInfo;

@end
