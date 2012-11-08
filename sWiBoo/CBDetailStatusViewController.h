//
//  CBDetailStatusViewController.h
//  sWiBoo
//
//  Created by ly on 11/1/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBStatusCell;
@interface CBDetailStatusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SinaWeiboRequestDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) CBStatusCell *headCell;
@property (nonatomic, assign) double headCellHeight;
@property (nonatomic, strong, readonly) SinaWeibo *weibo;
@property (nonatomic, strong) NSString *lastCommentID;
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *status_idstr;

@end
