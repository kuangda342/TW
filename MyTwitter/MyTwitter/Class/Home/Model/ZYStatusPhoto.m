#import "ZYStatusPhoto.h"
#import "ZYPhoto.h"
#import "UIImageView+WebCache.h"
#import "UIView+SizeExtension.h"
#import "UIButton+WebCache.h"
@interface ZYStatusPhoto()
//@property (nonatomic,strong)UIButton *cover;
@property (nonatomic, weak) UIImageView *gifView;
@end
@implementation ZYStatusPhoto
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    return self;
}
-(void)setPhoto:(ZYPhoto *)photo{
    _photo = photo;
    
    // 设置图片
    NSString *thumbnail=photo.thumbnail_pic;
    NSString *bmiddle=[thumbnail stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    NSLog(@"%@",bmiddle);
    NSURL *url1=[NSURL URLWithString:thumbnail];
    NSURL *url2=[NSURL URLWithString:bmiddle];
    [self sd_setBackgroundImageWithURL:url1 forState:UIControlStateNormal];
    [self sd_setBackgroundImageWithURL:url2 forState:UIControlStateSelected];
    [self addTarget:self action:@selector(pictureclick) forControlEvents:UIControlEventTouchUpInside];
    
    // 显示\隐藏gif控件
    // 判断是够以gif或者GIF结尾
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
}
-(void)pictureclick{
    self.selected=YES;

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}




@end
