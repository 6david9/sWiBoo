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

@implementation CBTimelineCell

@synthesize name = _name;
@synthesize numComment = _numComment;
@synthesize numRetweet = _numRetweet;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Method
- (void)setName:(NSString *)name
{
    _name = name;
    nameLabel.text = _name;
}

- (void)setNumComment:(NSUInteger)numComment
{
    _numComment = numComment;
   
    NSString *commentStr = [NSString stringWithFormat:@"%d", numComment];
    numCommentLabel.text = commentStr;
}

- (void)setNumRetweet:(NSUInteger)numRetweet
{
    _numRetweet = numRetweet;
   
    NSString *retweetStr = [NSString stringWithFormat:@"%d", numRetweet];
    numRetweetLabel.text = retweetStr;
}

- (void)setAvatarWithURL:(NSURL *)URL
{
    [avatarView setImageWithURL:URL];
}

- (void)setContent:(NSString *)content andImageWithURL:(NSURL *)URL 
{
    CGFloat contentWidth = TimelineContentView.bounds.size.width;
    
    [TimelineContentView setText:content andImageWithURL:URL width:contentWidth];
    [TimelineContentView setNeedsDisplay];
}

- (CGFloat)heihgt
{
    return (64 + TimelineContentView.frame.size.height);
}

@end
