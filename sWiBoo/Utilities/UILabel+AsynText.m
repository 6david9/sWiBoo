//
//  UILabel+AsynText.m
//  sWiBoo
//
//  Created by ly on 10/20/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "UILabel+AsynText.h"

@implementation UILabel (AsynText)

- (void)setTextWithURL:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSString *asynText = [NSString stringWithContentsOfURL:url
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
        if (error != nil)
            NSLog(@"%@", error);
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = asynText;
            });
    });
}

@end
