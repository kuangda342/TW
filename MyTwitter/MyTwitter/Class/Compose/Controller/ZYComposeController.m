#import "ZYComposeController.h"
#import "ZYAccount.h"
#import "ZYSaveTool.h"
#import "UIView+SizeExtension.h"
#import "ZYEmotionTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYComposeToolBar.h"
#import "ZYComposePhotosView.h"
#import "ZYEmotionKeyboard.h"
@interface ZYComposeController ()<UITextViewDelegate,ZYComposeToolbarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) ZYEmotionTextView *textView;
@property (nonatomic, assign) BOOL switchingKeyboard;
@property (nonatomic, weak) ZYComposeToolBar *toolbar;
/** 相册（存放拍照或者相册中选择的图片） */
@property (nonatomic, weak) ZYComposePhotosView *photosView;
@property (nonatomic, strong) ZYEmotionKeyboard *emotionKeyboard;
@end

@implementation ZYComposeController
- (ZYEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[ZYEmotionKeyboard alloc] init];
        // 键盘的宽度
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setupNav];
    [self setupTextView];
    [self setupToolbar];
    
    // 添加相册
    [self setupPhotosView];

}
-(void)setupToolbar{
    ZYComposeToolBar *toolbar = [[ZYComposeToolBar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;



}
-(void)setupPhotosView{
    ZYComposePhotosView *photosView = [[ZYComposePhotosView alloc] init];
    photosView.y = 100;
    photosView.width = self.view.width;
    // 随便写的
    photosView.height = 210;
    [self.textView addSubview:photosView];
    self.photosView = photosView;



}

-(void)setupTextView{
    // 在这个控制器中，textView的contentInset.top默认会等于64
    ZYEmotionTextView *textView = [[ZYEmotionTextView alloc] init];
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.delegate = self;
    textView.placeholder = @"分享新鲜事...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:@"selectemotion" object:nil];
//
//    // 删除文字的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:@"deleteemotion" object:nil];


}
-(void)emotionDidSelect:(NSNotification *)notification{

    ZYEmotion *emotion = notification.userInfo[@"selectemotionkey"];
    [self.textView insertEmotion:emotion];


}
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)textDidChange
{
    
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeyboard) return;
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled=NO;

}
-(void)setupNav{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    
    
    ZYAccount *account=[ZYSaveTool account];
    NSString *name=account.name;
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        titleView.y = 50;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;

    }else{
    self.title = prefix;
    
    }


}
-(void)cancel{
[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)send{
    if (self.photosView.photos.count) {
        [self sendWithImage];
    } else {
        [self sendWithoutImage];
    }
[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendWithImage
{
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [ZYSaveTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

/**
 * 发布没有图片的微博
 */
- (void)sendWithoutImage
{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [ZYSaveTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

- (void)composeToolbar:(ZYComposeToolBar *)toolbar didClickButton:(ZYComposeToolbarBtnType)buttonType
{
    switch (buttonType) {
        case ZYComposeToolbarBtnTypeCamera: // 拍照
            [self openCamera];
            break;
            
        case ZYComposeToolbarBtnTypePicture: // 相册
            [self openAlbum];
            break;
            
        case ZYComposeToolbarBtnTypeMention: // @
            break;
            
        case ZYComposeToolbarBtnTypeTrend: // #
            break;
            
        case ZYComposeToolbarBtnTypeEmotion: // 表情\键盘
            [self switchKeyboard];
            break;
    }
}
- (void)switchKeyboard
{
    // self.textView.inputView == nil : 使用的是系统自带的键盘
    if (self.textView.inputView == nil) { // 切换为自定义的表情键盘
        self.textView.inputView = self.emotionKeyboard;
        
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    } else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
        
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    
    // 开始切换键盘
    self.switchingKeyboard = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];
    
    // 结束切换键盘
    self.switchingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
    });
}



- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    [self openImagePickerController:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中
    [self.photosView addPhoto:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
