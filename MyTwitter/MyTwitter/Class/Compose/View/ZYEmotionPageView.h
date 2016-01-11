
#import <UIKit/UIKit.h>
// 一页中最多3行
#define ZYEmotionMaxRows 3
// 一行中最多7列
#define ZYEmotionMaxCols 7
// 每一页的表情个数
#define ZYEmotionPageSize ((ZYEmotionMaxRows * ZYEmotionMaxCols) - 1)

@interface ZYEmotionPageView : UIView
/** 这一页显示的表情（里面都是HWEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;

@end
