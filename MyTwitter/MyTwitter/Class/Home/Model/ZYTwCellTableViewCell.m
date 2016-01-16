#import "ZYTwCellTableViewCell.h"
#import "ZYStatus.h"
#import "ZYUserInfo.h"
#import "ZYStatusFrame.h"
#import "ZYPhoto.h"
#import "UIImageView+WebCache.h"
#import "ZYStatusTool.h"
#import "ZYStatusPhotos.h"
#import "ZYIcon.h"
#import "NSString+Extension.h"
#import "ZYEmotion.h"
#import "MJExtension.h"
#import "NSString+test.h"
#import <UIKit/UIDataDetectors.h>
@interface ZYTwCellTableViewCell()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) ZYIcon *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) ZYStatusPhotos *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;

/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) ZYStatusPhotos *retweetPhotosView;

/** 工具条 */
@property (nonatomic, weak) ZYStatusTool *toolbar;

@end

@implementation ZYTwCellTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    ZYTwCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZYTwCellTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置选中时的背景为蓝色
        //        UIView *bg = [[UIView alloc] init];
        //        bg.backgroundColor = [UIColor blueColor];
        //        self.selectedBackgroundView = bg;
        
        // 这个做法不行
        //        self.selectedBackgroundView.backgroundColor = [UIColor blueColor];
        
        // 初始化原创微博
        [self setupOriginal];
        
        // 初始化转发微博
        [self setupRetweet];
        
        // 初始化工具条
        [self setupToolbar];
    }
    return self;
}
/**
 * 初始化工具条
 */
- (void)setupToolbar
{
    ZYStatusTool *toolbar = [ZYStatusTool toolbar];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}

/**
 * 初始化转发微博
 */
- (void)setupRetweet
{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.font = [UIFont systemFontOfSize:13];
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    ZYStatusPhotos *retweetPhotosView = [[ZYStatusPhotos alloc] init];
    [retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
}

/**
 * 初始化原创微博
 */
- (void)setupOriginal
{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    ZYIcon *iconView = [[ZYIcon alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    ZYStatusPhotos *photosView = [[ZYStatusPhotos alloc] init];
    [originalView addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = [UIFont systemFontOfSize:12];
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setStatusFrame:(ZYStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    ZYStatus *status = statusFrame.status;
    ZYUserInfo *user = status.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = user;
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photosViewF;
        self.photosView.photos = status.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = status.created_at;
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF) + 10;
    CGSize timeSize = [time sizeWithFont:[UIFont systemFontOfSize:12]];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + 10;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:[UIFont systemFontOfSize:12]];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = status.source;
    
    /** 正文 */
    NSAttributedString *deal= [NSString stringToAttributeString:status.text];
    
    self.contentLabel.attributedText=deal;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    /** 被转发的微博 */
    if (status.retweeted_status) {
        ZYStatus *retweeted_status = status.retweeted_status;
        ZYUserInfo *retweeted_status_user = retweeted_status.user;
        
        self.retweetView.hidden = NO;
        /** 被转发的微博整体 */
        self.retweetView.frame = statusFrame.retweetViewF;
        
        /** 被转发的微博正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        NSAttributedString *retwt=[NSString stringToAttributeString:retweetContent];
        self.retweetContentLabel.attributedText = retwt;
        
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        
        /** 被转发的微博配图 */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        } else {
            self.retweetPhotosView.hidden = YES;
        }
    } else {
        self.retweetView.hidden = YES;
    }
    
    /** 工具条 */
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = status;
}

@end
