#import <UIKit/UIKit.h>
@class ZYStatus;
@interface ZYStatusTool : UIView
+ (instancetype)toolbar;
@property (nonatomic, strong) ZYStatus *status;

@end
