#import "ZYTabbarController.h"
#import "ZYHomeController.h"
#import "ZYMessageController.h"
#import "ZYProfileController.h"
#import "ZYDiscoverController.h"
#import "ZYTabbar.h"
#import "ZYComposeController.h"
#import "ZYnavigationController.h"
@interface ZYTabbarController ()<ZYTabbarDelegate>

@end

@implementation ZYTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYHomeController *home=[[ZYHomeController alloc]init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    ZYMessageController *msg=[[ZYMessageController alloc]init];
    [self addChildVc:msg title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    ZYDiscoverController *disc=[[ZYDiscoverController alloc]init];
    [self addChildVc:disc title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    ZYProfileController *pro=[[ZYProfileController alloc]init];
     [self addChildVc:pro title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    ZYTabbar *tab=[[ZYTabbar alloc]init];
    [self setValue:tab forKey:@"tabBar"];
    
    
    
    
    
    
    
    
    
}
-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    childVc.title=title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    ZYnavigationController *nav=[[ZYnavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];



}
-(void)tabbarDidClickPlusBtn:(ZYTabbar *)tabBar{
    ZYComposeController *comp=[[ZYComposeController alloc]init];
    ZYnavigationController *nav=[[ZYnavigationController alloc]initWithRootViewController:comp];
    [self presentViewController:nav animated:YES completion:nil];

}
@end
