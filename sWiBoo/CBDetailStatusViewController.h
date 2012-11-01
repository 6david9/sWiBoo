//
//  CBDetailStatusViewController.h
//  sWiBoo
//
//  Created by ly on 11/1/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBTimelineCell;
@interface CBDetailStatusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CBTimelineCell *headCell;
@property (nonatomic, assign) double headCellHeight;

@end
