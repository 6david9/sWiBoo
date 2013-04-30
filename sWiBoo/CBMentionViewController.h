//
//  CBMentionViewController.h
//  sWiBoo
//
//  Created by ly on 13-2-20.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBFollower;
@protocol  SinaWeiboRequestDelegate;

@protocol CBMentionDelgate <NSObject>

- (void)userDidSelectFollower:(CBFollower *)follower;

@end

@interface CBMentionViewController : UIViewController <SinaWeiboRequestDelegate,
                                                        UITableViewDataSource,
                                                        UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableArray *list;
@property (weak, nonatomic) id<CBMentionDelgate> delegate;

@end
