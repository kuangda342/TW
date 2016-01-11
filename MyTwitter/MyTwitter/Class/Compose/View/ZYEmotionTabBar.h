
#import <UIKit/UIKit.h>
typedef enum {
    ZYEmotionTabBarButtonTypeRecent, // 最近
    ZYEmotionTabBarButtonTypeDefault, // 默认
    ZYEmotionTabBarButtonTypeEmoji, // emoji
    ZYEmotionTabBarButtonTypeLxh, // 浪小花
} ZYEmotionTabBarButtonType;
@class ZYEmotionTabBar;
@protocol ZYEmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(ZYEmotionTabBar *)tabBar didSelectButton:(ZYEmotionTabBarButtonType)buttonType;
@end

@interface ZYEmotionTabBar : UIView
@property (nonatomic, weak) id<ZYEmotionTabBarDelegate> delegate;
@end
