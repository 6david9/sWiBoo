//
//  CBStartViewController.h
//  sWiBoo
//
//  Created by ly on 10/24/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class SinaWeibo;
@class CBAppDelegate;
@interface CBStartViewController : UIViewController <SinaWeiboDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) SinaWeibo *weibo;
@property (weak, nonatomic) CBAppDelegate *appDelegate;
@property (strong, nonatomic) UITabBarController *mainTabbarController;

- (IBAction)login:(id)sender;

@end
