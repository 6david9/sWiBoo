//
//  CBDetailStatusViewController.h
//  sWiBoo
//
//  Created by ly on 11/1/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBCommentSet.h"

@class CBStatus;
@interface CBDetailStatusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SinaWeiboRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) CBStatus *status;
@property (strong, nonatomic) CBCommentSet *list;

@end
