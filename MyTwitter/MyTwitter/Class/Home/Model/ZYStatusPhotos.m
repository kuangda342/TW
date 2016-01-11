#import "ZYStatusPhotos.h"
#import "ZYPhoto.h"
#import "ZYStatusPhoto.h"
#import "UIView+SizeExtension.h"
#define ZYStatusPhotoWH 70
#define ZYStatusPhotoMargin 10
#define ZYStatusPhotoMaxCol(count) ((count==4)?2:3)

@implementation ZYStatusPhotos
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSUInteger photosCount = photos.count;
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        ZYStatusPhoto *photoView = [[ZYStatusPhoto alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        ZYStatusPhoto *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = ZYStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        ZYStatusPhoto *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (ZYStatusPhotoWH + ZYStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (ZYStatusPhotoWH + ZYStatusPhotoMargin);
        photoView.width = ZYStatusPhotoWH;
        photoView.height = ZYStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = ZYStatusPhotoMaxCol(count);
    
    ///Users/apple/Desktop/课堂共享/05-iPhone项目/1018/代码/黑马微博2期35-相册/黑马微博2期/Classes/Home(首页)/View/ZYStatusPhotosView.m 列数
    NSUInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * ZYStatusPhotoWH + (cols - 1) * ZYStatusPhotoMargin;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * ZYStatusPhotoWH + (rows - 1) * ZYStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
