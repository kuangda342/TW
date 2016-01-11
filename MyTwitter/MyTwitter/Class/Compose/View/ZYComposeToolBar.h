
#import <UIKit/UIKit.h>
typedef enum {
    ZYComposeToolbarBtnTypeCamera, // 拍照
    ZYComposeToolbarBtnTypePicture, // 相册
    ZYComposeToolbarBtnTypeMention, // @
    ZYComposeToolbarBtnTypeTrend, // #
    ZYComposeToolbarBtnTypeEmotion // 表情
} ZYComposeToolbarBtnType;
@class ZYComposeToolBar;
@protocol ZYComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(ZYComposeToolBar *)toolbar didClickButton:(ZYComposeToolbarBtnType)buttonType;
@end
@interface ZYComposeToolBar : UIView
@property (nonatomic, weak) id<ZYComposeToolbarDelegate> delegate;
/** 是否要显示键盘按钮  */
@property (nonatomic, assign) BOOL showKeyboardButton;


@end
