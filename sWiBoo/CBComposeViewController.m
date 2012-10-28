//
//  CBComposeViewController.m
//  sWiBoo
//
//  Created by ly on 10/26/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBComposeViewController.h"
#import "CBAppDelegate.h"
#import "CBEmotionView.h"

@interface CBComposeViewController ()

- (void)adjustContainerSize:(NSDictionary *)notification;

@end

@implementation CBComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Compose", @"发微博");
        //添加发送按钮
        UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"send", @"发送微博按钮title") style:UIBarButtonItemStyleBordered target:self action:@selector(compose)];
        self.navigationItem.rightBarButtonItem = compose;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 监视键盘显示或隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContainerSize:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContainerSize:) name:UIKeyboardWillHideNotification object:nil];
    
    // 显示键盘
    [self.textView becomeFirstResponder];
    _showEmotions = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)compose
{
    [self.textView resignFirstResponder];
}

- (void)adjustContainerSize:(NSDictionary *)notification
{
    // 保存变化前的frame的大小
    __block CGRect aFrame = self.containerView.frame;
    
    NSString *notificationName = [notification valueForKey:@"name"];
    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    
    CGRect keyboardFrame = [[userInfo valueForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat duration = [[userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue]; 

    // 计算更改后的container的frame
    if ([notificationName isEqualToString:UIKeyboardWillShowNotification])
       aFrame.size.height -= keyboardFrame.size.height;
    else 
        aFrame.size.height += keyboardFrame.size.height;

    // 动画效果，更改container的frame
    [UIView animateWithDuration:duration animations:^{
        self.containerView.frame = aFrame;
        self.inputWindowBackgroudView.frame = aFrame;
    }];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self setInputWindowBackgroudView:nil];
    [self setLocationButton:nil];
    [self setPictureButton:nil];
    [self setEmotionButton:nil];
    [super viewDidUnload];
}


- (IBAction)addLocationInfo:(id)sender
{
    
}

- (NSString *)emotionRootPath
{
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    
    return [mainBundlePath stringByAppendingPathComponent:@"Emotions"];
}

- (IBAction)showEmotion:(id)sender
{
    _showEmotions = !_showEmotions;
    if (_showEmotions) {
        CBEmotionView *emotionView = [[CBEmotionView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        [self.textView resignFirstResponder];
        self.textView.inputView = emotionView;
        [self.textView becomeFirstResponder];
    } else {
        [self.textView resignFirstResponder];
        self.textView.inputView = nil;
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - Add Image
- (IBAction)takePicture:(id)sender
{
    UIActionSheet *choosePictureSourceSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select a  Picture Type", @"选择上传图片类型") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"取消上传") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Select a picture from album", @"从相册选择"), NSLocalizedString(@"Take a new picture", @"现在拍一张照片"), nil];
    [choosePictureSourceSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case kAlbumIndex:
            NSLog(@"从相册添加图片");
            break;
          
        case kCameraIndex:
            NSLog(@"拍一张新的照片");
            break;
            
        default:
            NSLog(@"取消上传照片");
            break;
    }
}

@end
