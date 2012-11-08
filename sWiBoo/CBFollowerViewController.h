//
//  CBFollowerViewController.h
//  sWiBoo
//
//  Created by ly on 11/4/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBFollowerCell;
@interface CBFollowerViewController : UIViewController<SinaWeiboRequestDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet CBFollowerCell *tmpFollowerCell;
@property (strong, nonatomic) UINib *cellNib;

@property (nonatomic, strong, readonly) SinaWeibo *weibo;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
