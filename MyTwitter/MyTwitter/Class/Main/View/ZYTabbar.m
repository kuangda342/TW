#import "ZYTabbar.h"
#import "UIView+SizeExtension.h"
@interface ZYTabbar()
@property (nonatomic, weak) UIButton *plusBtn;
@end
@implementation ZYTabbar
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UIButton *plusBtn=[[UIButton alloc]init];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        plusBtn.size=plusBtn.currentBackgroundImage.size;
        [plusBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        self.plusBtn=plusBtn;
    }
    return self;
}
-(void)plusClick{
    if([self.delegate respondsToSelector:@selector(tabbarDidClickPlusBtn:)]){
        [self.delegate tabbarDidClickPlusBtn:self];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.plusBtn.centerX=self.width*0.5;
    self.plusBtn.centerY=self.height*0.5;
    CGFloat tabbarBtnWidth=self.width*0.2;
    CGFloat tabbarBtnIndex=0;
    for(UIView *child in self.subviews){
        Class class=NSClassFromString(@"UITabBarButton");
        if([child isKindOfClass:class]){
            child.width=tabbarBtnWidth;
            child.x=tabbarBtnIndex*tabbarBtnWidth;
            tabbarBtnIndex++;
            if(tabbarBtnIndex==2){
                tabbarBtnIndex++;
            
            }
        
        }
    
    
    }



}



@end
