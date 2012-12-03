//
//  CBStatusTextView.m
//  CBStatusCell
//
//  Created by ly on 11/15/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBStatusTextView.h"
#import "NSString+MD5.h"
#import "UIImageView+WebCache.h"

@interface CBStatusTextView ()

@property (assign, nonatomic) CGFloat textHeight;
@property (assign, nonatomic) CGFloat imageHeight;

- (NSData *)localImageDataWithIdentifier:(NSString *)identifier;
- (void)saveImage:(NSData *)data withIdentifier:(NSString *)identifier;
- (NSString *)imageSavingPath;

@end

@implementation CBStatusTextView
{
//    __block UIImage __strong *_img;
}


@synthesize textHeight = _textHeight;
@synthesize text = _text;
@synthesize image = _image;
@synthesize backgroudImage = _backgroudImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
    }
    
    return self;
}

- (CGFloat)height
{
    return (self.textHeight + self.imageHeight);
}

- (void)setText:(NSString *)text
{
    if (![_text isEqualToString:text]) {
        _text = nil;
        _text = text;
    }
    CGSize constrainedSize = CGSizeMake(self.bounds.size.width, 10000);
    _textHeight = [self.text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constrainedSize].height;
}

- (void)setImage:(UIImage *)image
{
    if (![_image isEqual:image]) {
        _image = nil;
        _image = image;
    }
    
    _imageHeight = (_image == nil) ? 0 : 50;
}

- (void)drawRect:(CGRect)rect
{
    [self.text drawInRect:CGRectMake(3, 3, self.bounds.size.width-3, self.bounds.size.height-3) withFont:[UIFont systemFontOfSize:13.0f]];
    [self.image drawInRect:CGRectMake(5, self.textHeight+3, 50, 50)];

}

- (void)setImageWithURL:(NSURL *)url
{
    if (url != nil) {
        self.image = [UIImage imageNamed:@"avatar_default_big.png"];    //  默认图片
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData;
            UIImage *img;

            imageData = [self localImageDataWithIdentifier:[url absoluteString]];   // 先从本地加载
            if (imageData == nil)   // 本地未缓存
                imageData = [NSData dataWithContentsOfURL:url];     // 联网下载
            
            [self saveImage:imageData withIdentifier:[url absoluteString]];         // 保存到本地路径
            img = [UIImage imageWithData:imageData];   // 设置新图片
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (img != nil) {
                    self.image = img;
                    [self setNeedsDisplay];
                }
            });
        });
    }
}

#pragma mark - Private Method
- (NSData *)localImageDataWithIdentifier:(NSString *)identifier
{
    NSString *filePath;
    filePath = [[self imageSavingPath] stringByAppendingPathComponent:[identifier md5HexDigest]];
    if (filePath == nil)    // 没有找到
        return nil;
    
    return [NSData dataWithContentsOfFile:filePath];
}

- (void)saveImage:(NSData *)data withIdentifier:(NSString *)identifier
{
    NSString *filePath;
    filePath = [[self imageSavingPath] stringByAppendingPathComponent:[identifier md5HexDigest]];
    [data writeToFile:filePath atomically:YES];
}

- (NSString *)imageSavingPath
{
    NSString *home;
    home = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return home;
}

@end
