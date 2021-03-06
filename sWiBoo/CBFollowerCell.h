//
//  CBFollowerCell.h
//  sWiBoo
//
//  Created by ly on 11/4/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface CBFollowerCell : UITableViewCell <SinaWeiboRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (weak, nonatomic) NSString *userId;
@property (assign, nonatomic) BOOL followMe;

- (IBAction)createOrDestroyFriendship:(UIButton *)sender;

@end
