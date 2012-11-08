//
//  CBStatusCell.h
//  WeiboStatusCell
//
//  Created by ly on 11/5/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultCellHeight   85
#define kSecondsPerDay       86400       // 24*60*60
#define kSecondsPerHour      3600        // 60*60
#define kSecondsPerMinutes   60          // 60

#define kLeftMargin         5
#define kTopMargin          5

#pragma mark - CBStatusCellDeleage
@class CBStatusCell;
@protocol CBStatusCellDelegate <NSObject>

@optional
- (void)tableCell:(CBStatusCell *)cell atIndexPathWasTapped:(NSIndexPath *)indexPath;

@end

#pragma mark - CBStatusCell
@class CBStatusView;
@interface CBStatusCell : UITableViewCell
{
    UIImageView *_avatarView;
    UILabel *_nameLabel;
    UIImageView *_commentIconView;
    UIImageView *_repostIconView;
    UILabel *_numCommentLabel;
    UILabel *_numRepostLabel;
    CBStatusView *_statusView;
    
    UILabel *_fromLabel;
    UILabel *_textFromLabel;
    BOOL _showFromLabel;
    
    UILabel *_timeLabel;
    BOOL _showTimeLabel;
}

/* 微博id
 * 默认: 空字符串
 */
@property (nonatomic, strong) NSString *status_idstr;

/* 代理,点击图片放大处理
 * 默认: nil
 */
@property (nonatomic, weak) id<CBStatusCellDelegate> delegate;

/* 是否显示占位图像
 * 默认: true
 */
@property (nonatomic, assign) BOOL showPlaceholderImage;

/* cell的indexPath
 * 默认: 
 *      indexPath.row = NSIntegerMax
 *      indexPath.section = NSIntegerMax
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/* cell高度
 * 默认: kDefaultCellHeight
 */
- (CGFloat)height;

/* 设置头像
 * 默认: 默认头像
 */
- (void)setAvatarWithURL:(NSURL *)URL;

/* 设置发布人姓名 
 * 默认: 未知
 */
- (void)setName:(NSString *)name;

/* 设置评论数
 * 默认: 0
 */
- (void)setCommentCount:(NSUInteger)count;

/* 设置转发数
 * 默认: 0
 */
- (void)setRepostCount:(NSUInteger)count;

/* 设置微博发布源
 * 默认: 不显示
 */
- (void)setSourceFrom:(NSString *)from;

/* 设置微博发布时间 
 * 默认: 不显示
 */
- (void)setCreateTime:(NSDate *)time;

/* 设置微博内容
 * - setWhatISaid: 便捷方法
 * - setWhatISaid:repostText:repostTextandImageWithURL: 完整方法
 */
- (void)setWhatISaid:(NSString *)text;
- (void)setWhatISaid:(NSString *)text repostText:(NSString *)repostText andImageWithURL:(NSURL *)URL;

@end


