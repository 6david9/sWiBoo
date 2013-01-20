//
//  CBRepostViewController.h
//  sWiBoo
//
//  Created by ly on 1/19/13.
//  Copyright (c) 2013 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBRepostViewController : UIViewController
<SinaWeiboRequestDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *statusId;

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@end
