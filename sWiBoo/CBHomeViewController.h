//
//  CBHomeViewController.h
//  sWiBoo
//
//  Created by ly on 10/24/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBStatusSet.h"
#import "PullTableView.h"

@class CBStatusCell;
@interface CBHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, SinaWeiboRequestDelegate, PullTableViewDelegate>


@property (weak, nonatomic) IBOutlet PullTableView *tableView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) SinaWeibo *weibo;
@property (strong, nonatomic) CBStatusSet *list;



@end