
#import "ZYEmotionPopView.h"
#import "ZYEmotion.h"
#import "ZYEmotionBtn.h"
#import "UIView+SizeExtension.h"
@interface ZYEmotionPopView()

@property (weak, nonatomic) IBOutlet ZYEmotionBtn *emotionButton;


@end
@implementation ZYEmotionPopView
+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZYEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFrom:(ZYEmotionBtn *)button
{
    if (button == nil) return;
    
    // 给popView传递数据
    self.emotionButton.emotion = button.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中的frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    self.y = CGRectGetMidY(btnFrame) - self.height; // 100
    self.centerX = CGRectGetMidX(btnFrame);
}


@end
