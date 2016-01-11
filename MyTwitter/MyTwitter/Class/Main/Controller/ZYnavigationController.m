#import "ZYnavigationController.h"
#import "UIBarButtonItem+BarBtnExtension.h"
@interface ZYnavigationController ()

@end

@implementation ZYnavigationController
+(void)initialize{
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    NSMutableDictionary *textAttr=[NSMutableDictionary dictionary];
    textAttr[NSForegroundColorAttributeName]=[UIColor orangeColor];
    textAttr[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttr forState:UIControlStateNormal];

    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttr[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];

}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed=YES;
        viewController.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        viewController.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];

    }
[super pushViewController:viewController animated:animated];


}




- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

@end
