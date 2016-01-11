
#import "ZYEmotionAttachment.h"
#import "ZYEmotion.h"
@implementation ZYEmotionAttachment
- (void)setEmotion:(ZYEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}

@end
