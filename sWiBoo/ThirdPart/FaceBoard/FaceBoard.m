//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"

@implementation FaceBoard
@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (void)dealloc
{
    [_faceMap release];
    [_inputTextField release];
    [_inputTextView release];
    [faceView release];
    [facePageControl release];
    [super dealloc];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 216)];
    if (self) {
        // 设置背景颜色
        self.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        
        // 获取系统语言
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        
        // 中文 or 英文
        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {
            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_ch" ofType:@"plist"]]retain];
        } else {
            _faceMap = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_en" ofType:@"plist"]]retain];
        }
       
        // 表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((85/28+1)*320, 190);  /* contentSize宽度为 页数*页宽
                                                                 * 85 为表情总数
                                                                 * 28 为每页最多显示表情数
                                                                 * (85/28)+1 相当于 ceil(85/28)向上取整
                                                                 */
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        // 添加表情faceButton
        for (int i = 1; i<=85; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];    /* 每个表情是个定制的button */
            faceButton.buttonIndex = i;     /* 添加索引
                                             * 点击faceButton后通过索引判断表情内容
                                             */
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            /* faceButton的宽和高为44
             * 每页最多显示28个表情
             * 每页左右各距离边框6像素，实际显示表情的区域为320-6*2点宽
             *
             * (i-1)%28 当前页第几个表情
             * (i-1)%28%7 当前页第几行
             * (i-1)%28%7*44 当前页所在行的x坐标
             * (i-1)*28%7*44+ 6 当前页坐标 + 左边距
             * (((i-1)%28)%7)*44+6+((i-1)/28*320 当前页坐标+页面偏移坐标
             *
             * (i-1)%28) 当前页第几个表情
             * ((i-1)%28)/7 当前页第几行
             * (((i-1)%28)/7)*44 y坐标偏移量
             * (((i-1)%28)/7)*44+8 y坐标偏移量 + 上边距
             */
            faceButton.frame = CGRectMake((((i-1)%28)%7)*44+6+((i-1)/28*320), (((i-1)%28)/7)*44+8, 44, 44);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d",i]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        
        // 添加键盘View
        [self addSubview:faceView];
        
        // 添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(110, 190, 100, 20)];
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];     // 当用户点击小圆点时触发
        
        facePageControl.numberOfPages = 85/28+1;    // ceil(85/28)
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        // 添加删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(270, 185, 38, 27);
        [self addSubview:back];
    }
    return self;
}

// 停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [facePageControl setCurrentPage:faceView.contentOffset.x/320];
    [facePageControl updateCurrentPageDisplay];
}

/* 点击pageControl时触发
 * 在每个方向上每次只前进一个页面
 * 通过currentPage判断当前页
 */
- (void)pageChange:(id)sender {
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage*320, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {
    // 获取表情索引
    int i = ((FaceButton*)sender).buttonIndex;
    
    /* 添加表情信息步骤
     * 1、拷贝原字符串
     * 2、追加表情信息
     * 3、设置控件中的文字为新生成字符串
     */
    if (self.inputTextField) {
        // 存储原始聊天记录
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        // 在原始聊天记录后追加表情文字
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]]];
        // 替换inputTextField中的文字为新和成文字
        self.inputTextField.text = faceString;
        [faceString release];
    }
    
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"%03d",i]]];
        self.inputTextView.text = faceString;
        [faceString release];
    }
}

- (void)backFace{
    NSString *inputString;
    // 保存输入框中的文字
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {   // 如果最后一个字符是']'
            if ([inputString rangeOfString:@"["].location == NSNotFound){   // 没有匹配的左括号'['
                string = [inputString substringToIndex:stringLength - 1];   // 字符串长度减1
            } else { // 从后搜索查找第一个左括号'[', substring左侧
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {    // 最后一个字符不是']'，不是表情,字符串长度减1
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextField.text = string;
    self.inputTextView.text = string;
}

@end
