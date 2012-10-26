//
//  UIImageView+AsynImage.m
//  sWiBoo
//
//  Created by ly on 10/20/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "UIImageView+AsynImage.h"
#import "NSString+MD5.h"

@interface UIImageView(Private)

- (NSData *)localImageDataWithIdentifier:(NSString *)identifier;
- (void)saveImage:(NSData *)data withIdentifier:(NSString *)identifier;
- (NSString *)imageSavingPath;

@end

@implementation UIImageView (AsynImage)

- (void)setImageWithURL:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [self localImageDataWithIdentifier:[url absoluteString]];   // 先从本地加载
        if (imageData == nil)   // 本地未缓存
            imageData = [NSData dataWithContentsOfURL:url];     // 联网下载
        
        [self saveImage:imageData withIdentifier:[url absoluteString]];         // 保存到本地路径
        UIImage *img = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = img;
        });
    });
}

#pragma mark - Private Method
- (NSData *)localImageDataWithIdentifier:(NSString *)identifier
{
    NSString *filePath = [[self imageSavingPath] stringByAppendingPathComponent:[identifier md5HexDigest]];
    if (filePath == nil)    // 没有找到
        return nil;
    
    return [NSData dataWithContentsOfFile:filePath];
}

- (void)saveImage:(NSData *)data withIdentifier:(NSString *)identifier
{
    NSString *filePath = [[self imageSavingPath] stringByAppendingPathComponent:[identifier md5HexDigest]];
    [data writeToFile:filePath atomically:YES];
}

- (NSString *)imageSavingPath
{
    NSString *home = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return home;
}

@end
