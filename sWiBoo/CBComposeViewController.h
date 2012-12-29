//
//  CBComposeViewController.h
//  sWiBoo
//
//  Created by ly on 10/26/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

// 用于选择添加照片时的数据源
#define kAlbumIndex    0
#define kCameraIndex   1

@class FaceBoard;

@interface CBComposeViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate, SinaWeiboRequestDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL _showEmotions;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *inputWindowBackgroudView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *emotionButton;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (strong, nonatomic) FaceBoard *faceBoard;


- (IBAction)addLocationInfo:(id)sender;
- (IBAction)choosePicture:(id)sender;
- (IBAction)showEmotion:(id)sender;
- (NSString *)emotionRootPath;

@end
