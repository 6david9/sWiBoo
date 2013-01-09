//
//  CBCommentCell.m
//  CBCommentCell
//
//  Created by ly on 1/9/13.
//  Copyright (c) 2013 Lei Yan. All rights reserved.
//

#import "CBCommentCell.h"

@implementation CBCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 288, 20)];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        self.commentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
        self.commentTextLabel.numberOfLines = 0;
        self.commentTextLabel.font = [UIFont systemFontOfSize:13.0f];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.commentTextLabel];
    }
    return self;
}

- (CGFloat)height
{
    NSString *text = self.commentTextLabel.text;
    CGSize constraintedSize = [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(280, 1000)];
    
    return (60 + constraintedSize.height-20);       /* 原有高度60pt，加上变化高度 */
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (void)setCommentText:(NSString *)commentText
{
    self.commentTextLabel.text = commentText;
    
    
    NSString *text = self.commentTextLabel.text;
    CGSize constraintedSize = [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(280, 1000)];

    self.commentTextLabel.frame = CGRectMake(20, 30, 280, constraintedSize.height);
}

@end
