#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 昵称字体
#define ZYStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define ZYStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define ZYStatusCellSourceFont ZYStatusCellTimeFont
// 正文字体
#define ZYStatusCellContentFont [UIFont systemFontOfSize:14]

// 被转发微博的正文字体
#define ZYStatusCellRetweetContentFont [UIFont systemFontOfSize:14]

// cell之间的间距
#define ZYStatusCellMargin 15

// cell的边框宽度
#define ZYStatusCellBorderW 10


@class ZYStatus;

@interface ZYStatusFrame : NSObject
@property (nonatomic, strong) ZYStatus *status;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotosViewF;

/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
