//
//  CBFollowerCell.m
//  sWiBoo
//
//  Created by ly on 11/4/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBFollowerCell.h"
#import "CBAppDelegate.h"

@implementation CBFollowerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer *layer = self.avatarView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    self.avatarView.image = nil;
    self.name.text = nil;
    [self.followButton setTitle:@"" forState:UIControlStateNormal];
}

- (SinaWeibo *)weibo
{
    return [(CBAppDelegate *)[[UIApplication sharedApplication] delegate] weibo];
}

- (IBAction)createOrDestroyFriendship:(UIButton *)sender
{
    NSLog(@"friendship: %@", self.userId);
    
    NSString *requestURLStr;
    if (self.followMe)      // 当前关注我，需要取消关注
        requestURLStr = @"friendships/destroy.json";
    else                
        requestURLStr = @"friendships/create.json";
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:1];
    [params setValue:self.userId forKey:@"uid"];
    [[self weibo] requestWithURL:requestURLStr params:params httpMethod:@"POST" delegate:self];
}

#pragma mark - Sina weibo Request
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    NSString *message;
    if ([error code]==20506) {  // already followed
        message = @"已经关注，请不要重复关注";
    } else if ([error code] == 20522) { // not followed
        message = @"还未关注，无法取消关注";
    }else {
        message = @"发生未知错误，请稍后重试";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.followMe = [[result valueForKey:@"follow_me"] boolValue];
    NSLog(@"follow:%d", [[result valueForKey:@"follow_me"] boolValue]);
    
    if ([request.url rangeOfString:@"friendships/create.json"].location != NSNotFound )
    {
        [self.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else if ([request.url rangeOfString:@"friendships/destroy.json"].location != NSNotFound)
    {
        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
}

@end
