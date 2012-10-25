//
//  CBTimelineCell.h
//  sWiBoo
//
//  Created by ly on 10/25/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBTimelineContentView;
@interface CBTimelineCell : UITableViewCell
{
    IBOutlet UIImageView *avatarView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *numCommentLabel;
    IBOutlet UILabel *numRetweetLabel;
    IBOutlet CBTimelineContentView *TimelineContentView;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger numComment;
@property (nonatomic, assign) NSUInteger numRetweet;

- (void)setAvatarWithURL:(NSURL *)URL;
- (void)setContent:(NSString *)content andImageWithURL:(NSURL *)URL;
- (CGFloat)heihgt;

@end
