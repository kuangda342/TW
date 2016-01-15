#import "UIImageView+scale.h"
#import "UIImageView+WebCache.h"

@interface UIImageView ()<UIGestureRecognizerDelegate>

@end
@implementation UIImageView (scale)
// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:) ];
    [tapGestureRecognizer setNumberOfTapsRequired:2];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:tapGestureRecognizer];
}
-(void)tapView:(UITapGestureRecognizer *)tapGestureRecognizer{

    [self removeFromSuperview];
}
// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    UIImageView *img=(UIImageView *)view;
    if (img.frame.size.width==[UIScreen mainScreen].bounds.size.width||img.frame.size.width<[UIScreen mainScreen].bounds.size.width)return;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        
        
        if (view.center.x<0.5*[UIScreen mainScreen].bounds.size.width-0.5*(img.frame.size.width-[UIScreen mainScreen].bounds.size.width))
        {
        [view setCenter:(CGPoint){0.5*[UIScreen mainScreen].bounds.size.width-0.5*(img.frame.size.width-[UIScreen mainScreen].bounds.size.width), view.center.y }];
        }
        if (view.center.x>0.5*[UIScreen mainScreen].bounds.size.width+0.5*(img.frame.size.width-[UIScreen mainScreen].bounds.size.width))
        {
            [view setCenter:(CGPoint){0.5*[UIScreen mainScreen].bounds.size.width+0.5*(img.frame.size.width-[UIScreen mainScreen].bounds.size.width), view.center.y }];
        }
        if (view.center.y<0.5*[UIScreen mainScreen].bounds.size.height-0.5*(img.frame.size.height-[UIScreen mainScreen].bounds.size.height))
        {
            [view setCenter:(CGPoint){view.center.x, 0.5*[UIScreen mainScreen].bounds.size.height-0.5*(img.frame.size.height-[UIScreen mainScreen].bounds.size.height) }];
        }
        if (view.center.y>0.5*[UIScreen mainScreen].bounds.size.height+0.5*(img.frame.size.height-[UIScreen mainScreen].bounds.size.height))
        {
            [view setCenter:(CGPoint){view.center.x, 0.5*[UIScreen mainScreen].bounds.size.height+0.5*(img.frame.size.height-[UIScreen mainScreen].bounds.size.height) }];
        }
        
        
        
        
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
+ (instancetype)scale :(NSString *)imgName and:(NSURL *)imgUrl
{
    UIImageView * showImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    showImgView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.5];
    showImgView.contentMode=UIViewContentModeScaleAspectFit;
    [showImgView setMultipleTouchEnabled:YES];
    [showImgView setUserInteractionEnabled:YES];
    if (imgName==nil) {
        [showImgView sd_setImageWithURL:imgUrl];
    }else{
    [showImgView setImage:[UIImage imageNamed:imgName]];
     }
    [showImgView addGestureRecognizerToView:showImgView];
     return showImgView;
}
@end
