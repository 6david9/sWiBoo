//
//  CBComposeViewController.m
//  sWiBoo
//
//  Created by ly on 10/26/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBComposeViewController.h"
#import "CBAppDelegate.h"
#import "FaceBoard.h"
#import "SinaWeibo.h"
#import "NSString+URLEncode.h"

@interface CBComposeViewController ()

@property (weak, nonatomic, readonly) SinaWeibo *weibo;
@property (assign, nonatomic) CGFloat originalHeight;

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
    
    // 视图的默认高度
    CGFloat navigationBarHeight = 44.0;
    self.originalHeight = [[UIScreen mainScreen] applicationFrame].size.height-navigationBarHeight;
    
    // 监视键盘显示或隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContainerSize:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustContainerSize:) name:UIKeyboardWillHideNotification object:nil];
    
    // 显示键盘
    [self.textView becomeFirstResponder];
    _showEmotions = NO;
    
    // 创建表情键盘
    self.faceBoard = [[FaceBoard alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

#pragma mark - Private Method
- (void)compose
{
    [self.textView resignFirstResponder];
    
    NSString *postString = self.textView.text;
//    postString = [postString substringWithRange:NSMakeRange(0, 140)];     // 截断前先判断长度，否则会溢出崩溃
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:self.weibo.accessToken forKey:@"access_token"];
    [params setValue:postString forKey:@"status"];
    [self.weibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error;
{
    // 发布失败
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"发布失败！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    // 发送成功
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"微博发布成功！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

- (void)adjustContainerSize:(NSDictionary *)notification
{
    // 保存变化前的frame的大小
    __block CGRect aFrame = self.containerView.frame;
    
    NSString *notificationName = [notification valueForKey:@"name"];
    NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    
    CGRect keyboardFrame = [[userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [[userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue]; 

    // 计算更改后的container的frame
    if ([notificationName isEqualToString:UIKeyboardWillShowNotification])
       aFrame.size.height = self.originalHeight - keyboardFrame.size.height;
    else 
        aFrame.size.height = self.originalHeight;

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
    // not implemented
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
        [self.textView resignFirstResponder];
        self.textView.inputView = self.faceBoard;
        self.faceBoard.inputTextView = self.textView;
        [self.textView becomeFirstResponder];
    } else {
        [self.textView resignFirstResponder];
        self.textView.inputView = nil;
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - Add Image
- (IBAction)choosePicture:(id)sender
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
            [self takePicture];
            break;
            
        default:
            NSLog(@"取消上传照片");
            break;
    }
}

- (void)takePicture
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];

        // 是否具有拍照功能？
        if ([availableMediaTypes containsObject:@"public.image"]) {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            self.imagePickerController.delegate = self;
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            self.imagePickerController.mediaTypes = @[@"public.image"];
            [self presentModalViewController:self.imagePickerController animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"设备不支持拍照功能" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"设备不支持拍照功能" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)dismissImagePickerController
{
    [self.imagePickerController dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqual:@"public.image"]) {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        [self dismissImagePickerController];
    } else {
        [self dismissImagePickerController];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePickerController];
}

@end
