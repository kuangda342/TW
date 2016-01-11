
#import "ZYEmotionTabBar.h"
#import "ZYComposeTabbarBtn.h"
#import "UIView+SizeExtension.h"
@interface ZYEmotionTabBar()
@property (nonatomic, weak) ZYComposeTabbarBtn *selectedBtn;

@end
@implementation ZYEmotionTabBar
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupBtn:@"最近" buttonType:ZYEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:ZYEmotionTabBarButtonTypeDefault];
         [self setupBtn:@"Emoji" buttonType:ZYEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:ZYEmotionTabBarButtonTypeLxh];

    }

    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i<btnCount; i++) {
        ZYComposeTabbarBtn *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}
- (void)setDelegate:(id<ZYEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    
    // 选中“默认”按钮
    [self btnClick:(ZYComposeTabbarBtn *)[self viewWithTag:ZYEmotionTabBarButtonTypeDefault]];
}

- (ZYComposeTabbarBtn *)setupBtn:(NSString *)title buttonType:(ZYEmotionTabBarButtonType)buttonType
{
    // 创建按钮
    ZYComposeTabbarBtn *btn = [[ZYComposeTabbarBtn alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    } else if (self.subviews.count == 4) {
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
    
    return btn;
}
- (void)btnClick:(ZYComposeTabbarBtn *)btn
{
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:btn.tag];
    }
}





@end
