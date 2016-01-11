
#import "ZYEmotionKeyboard.h"
#import "MJExtension.h"
#import "ZYEmotion.h"
#import "ZYEmotionListView.h"
#import "ZYEmotionTabBar.h"
#import "ZYEmotionTool.h"
#import "UIView+SizeExtension.h"
@interface ZYEmotionKeyboard()<ZYEmotionTabBarDelegate>

@property (nonatomic, weak) ZYEmotionListView *showingListView;
/** 表情内容 */
@property (nonatomic, strong) ZYEmotionListView *recentListView;
@property (nonatomic, strong) ZYEmotionListView *defaultListView;
@property (nonatomic, strong) ZYEmotionListView *emojiListView;
@property (nonatomic, strong) ZYEmotionListView *lxhListView;
/** tabbar */
@property (nonatomic, weak) ZYEmotionTabBar *tabBar;

@end
@implementation ZYEmotionKeyboard
- (ZYEmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[ZYEmotionListView alloc] init];
        // 加载沙盒中的数据
        self.recentListView.emotions = [ZYEmotionTool recentEmotions];
    }
    return _recentListView;
}

- (ZYEmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[ZYEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"default.plist" ofType:nil];
        self.defaultListView.emotions = [ZYEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultListView;
}

- (ZYEmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[ZYEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        self.emojiListView.emotions = [ZYEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiListView;
}

- (ZYEmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[ZYEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lxh.plist" ofType:nil];
        self.lxhListView.emotions = [ZYEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhListView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // tabbar
        ZYEmotionTabBar *tabBar = [[ZYEmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect) name:@"selectemotion" object:nil];
    }
    return self;
}
-(void)emotionDidSelect{
self.recentListView.emotions = [ZYEmotionTool recentEmotions];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.tabbar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
}
- (void)emotionTabBar:(ZYEmotionTabBar *)tabBar didSelectButton:(ZYEmotionTabBarButtonType)buttonType
{
    // 移除正在显示的listView控件
    [self.showingListView removeFromSuperview];
    
    // 根据按钮类型，切换键盘上面的listview
    switch (buttonType) {
        case ZYEmotionTabBarButtonTypeRecent: { // 最近
            // 加载沙盒中的数据
            //            self.recentListView.emotions = [HWEmotionTool recentEmotions];
            [self addSubview:self.recentListView];
            break;
        }
            
        case ZYEmotionTabBarButtonTypeDefault: { // 默认
            [self addSubview:self.defaultListView];
            break;
        }
            
        case ZYEmotionTabBarButtonTypeEmoji: { // Emoji
            [self addSubview:self.emojiListView];
            break;
        }
            
        case ZYEmotionTabBarButtonTypeLxh: { // Lxh
            [self addSubview:self.lxhListView];
            break;
        }
    }
    
    // 设置正在显示的listView
    self.showingListView = [self.subviews lastObject];
    
    // 设置frame
    [self setNeedsLayout];
}

@end
