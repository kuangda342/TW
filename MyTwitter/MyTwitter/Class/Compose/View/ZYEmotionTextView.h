
#import "ZYTextView.h"
@class ZYEmotion;

@interface ZYEmotionTextView : ZYTextView
- (void)insertEmotion:(ZYEmotion *)emotion;
- (NSString *)fullText;
@end
