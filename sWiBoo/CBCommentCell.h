//
//  CBCommentCell.h
//  CBCommentCell
//
//  Created by ly on 1/9/13.
//  Copyright (c) 2013 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCommentCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *commentTextLabel;

- (CGFloat)height;

- (void)setName:(NSString *)name;
- (void)setCommentText:(NSString *)commentText;

@end
