
#import "ZYEmotion.h"
#import "MJExtension.h"
@implementation ZYEmotion
MJCodingImplementation

- (BOOL)isEqual:(ZYEmotion *)other
{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}

@end
