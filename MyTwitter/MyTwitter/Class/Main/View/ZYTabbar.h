#import <UIKit/UIKit.h>
@class ZYTabbar;
@protocol ZYTabbarDelegate <UITabBarDelegate>
@optional
-(void)tabbarDidClickPlusBtn:(ZYTabbar *)tabBar;
@end

@interface ZYTabbar : UITabBar
@property(nonatomic,weak) id<ZYTabbarDelegate>delegate;
@end
