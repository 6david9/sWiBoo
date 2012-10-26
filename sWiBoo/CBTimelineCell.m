//
//  CBTimelineCell.m
//  sWiBoo
//
//  Created by ly on 10/25/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBTimelineCell.h"

#import "UIImageView+AsynImage.h"
#import "CBTimelineContentView.h"

@interface CBTimelineCell ()

@property (strong, atomic) NSString *content;
@property (strong, atomic) NSURL *url;
@property (assign, atomic) BOOL hasImage;

@end

@implementation CBTimelineCell

@synthesize name = _name;
@synthesize numComment = _numComment;
@synthesize numRetweet = _numRetweet;

@synthesize content = _content;
@synthesize url = _url;         // 正文内容中的图片url地址
@synthesize hasImage = _hasImage;

- (void)prepareForReuse
{
    [TimelineContentView resetContent];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    NSLog(@"selected row height: %f", [self heihgt]);

    // Configure the view for the selected state
}

#pragma mark - Public Method
- (void)setName:(NSString *)name
{
    _name = name;
    if (_name)
        nameLabel.text = _name;
}

- (void)setNumComment:(NSUInteger)numComment
{
    _numComment = numComment;
    
    if (_numComment) {
        NSString *commentStr = [NSString stringWithFormat:@"%d", numComment];
        numCommentLabel.text = commentStr;
    }
}

- (void)setNumRetweet:(NSUInteger)numRetweet
{
    _numRetweet = numRetweet;
   
    if (_numRetweet) {
        NSString *retweetStr = [NSString stringWithFormat:@"%d", numRetweet];
        numRetweetLabel.text = retweetStr;
    } 
}

- (void)setAvatarWithURL:(NSURL *)URL
{
    if (URL)
        [avatarView setImageWithURL:URL];
}

- (void)setContent:(NSString *)content andImageWithURL:(NSURL *)URL 
{
    if ( (_content = content) ) { //赋值并测试
        if ( (_url = URL) )       // 赋值并测试
            _hasImage = YES;
        
        // 获取原始宽度
        CGFloat contentWidth = TimelineContentView.bounds.size.width;
    
        [TimelineContentView setText:_content andImageWithURL:_url width:contentWidth];
    }
}

- (CGFloat)heihgt
{
    if (_content) {
        CGFloat contentHeight = 21;
        CGFloat fontSize = 13.0f;
        UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
        
        CGFloat contentWidth = TimelineContentView.frame.size.width;
        CGSize constrainedSize = CGSizeMake(contentWidth, 500);
        CGSize newSize = [_content sizeWithFont:systemFont constrainedToSize:constrainedSize];
        
//        contentHeight = newSize.height + (_hasImage ? 53 : 0);
        contentHeight = newSize.height + 103;
        
        TimelineContentView.textHeight = newSize.height;
        TimelineContentView.frame = CGRectMake(20, 43, contentWidth, contentHeight);
        self.contentView.bounds = CGRectMake(0, 0, 320, 64+contentHeight);
        
        return (64 + contentHeight);
    } else
        return 0;
}

@end
