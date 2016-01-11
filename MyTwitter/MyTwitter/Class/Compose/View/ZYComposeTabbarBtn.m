
#import "ZYComposeTabbarBtn.h"

@implementation ZYComposeTabbarBtn
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        self.titleLabel.font=[UIFont systemFontOfSize:13];
    }
    return self;
    
}
- (void)setHighlighted:(BOOL)highlighted {
    // 按钮高亮所做的一切操作都不在了
}

@end
