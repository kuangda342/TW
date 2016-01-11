#import "ZYHomeController.h"
#import "UIBarButtonItem+BarBtnExtension.h"
#import "ZYTittlebtn.h"
#import "ZYDropDownMenu.h"
#import "ZYDropController.h"
#import "UIView+SizeExtension.h"
#import "ZYSaveTool.h"
#import "ZYAccount.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ZYNetTool.h"
#import "ZYUserInfo.h"
#import "ZYStatusFrame.h"
#import "ZYStatus.h"
#import "ZYTwCellTableViewCell.h"
@interface ZYHomeController ()<ZYDropDownMenuDelegate>
@property (nonatomic, strong) NSMutableArray *wbMdls;
@end

@implementation ZYHomeController
-(NSMutableArray *)wbMdls{
    if (_wbMdls==nil) {
        _wbMdls=[NSMutableArray array];
    }
    return _wbMdls;
}
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (ZYStatus *status in statuses) {
        ZYStatusFrame *f = [[ZYStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    [self setupNav];
    [self setupUserInfo];
    [self setupDownRefresh];
    [self setupUpRefresh];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    
}
- (void)setupUnreadCount
{
    // 1.拼接请求参数
    ZYAccount *account = [ZYSaveTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2.发送请求
    [ZYNetTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id json) {
        // 设置提醒数字(微博的未读数)
        NSString *status = [json[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(NSError *error) {
    }];
}

-(void)setupDownRefresh{

    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    
    [self.tableView headerBeginRefreshing];

}

-(void)setupUpRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
    [self.tableView footerBeginRefreshing];
}
-(void)loadMoreStatus{
    // 1.拼接请求参数
    ZYAccount *account = [ZYSaveTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    ZYStatusFrame *lastStatusF = [self.wbMdls lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 2.发送请求
    [ZYNetTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [ZYStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.wbMdls addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        
        // 结束刷新
        [self.tableView footerEndRefreshing];
    }];



}
- (void)showNewStatusCount:(NSUInteger)count
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"没有新的微博数据，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%zd条新的微博数据", count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    // 将label添加到导航控制器的view中，并且是盖在导航栏下边
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    // 先利用1s的时间，让label往下移动一段距离
    CGFloat duration = 1.0; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态）
        CGFloat delay = 1.0; // 延迟1s
        // UIViewAnimationOptionCurveLinear:匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}




-(void)loadNewStatus{
    ZYAccount *account=[ZYSaveTool account];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"access_token"]=account.access_token;
    ZYStatusFrame *firstStatusF = [self.wbMdls firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        param[@"since_id"] = firstStatusF.status.idstr;
    }
    
    // 2.发送请求
    [ZYNetTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:param success:^(id json) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [ZYStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        // 将最新的微博数据，添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.wbMdls insertObjects:newFrames atIndexes:set];
        // 刷新表格
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self showNewStatusCount:newStatuses.count];
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
    }];
}
-(void)setupNav{
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    ZYTittlebtn *btn=[[ZYTittlebtn alloc]init];
    NSString *name=[ZYSaveTool account].name;
    [btn setTitle:name?name:@"首页" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btn;
}

-(void)setupUserInfo{
    ZYAccount *account=[ZYSaveTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2.发送请求
    [ZYNetTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        ZYUserInfo *user = [ZYUserInfo objectWithKeyValues:json];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = user.name;
        [ZYSaveTool saveAccount:account];
    } failure:^(NSError *error) {
     }];



}

-(void)titleClick:(UIButton *)titleButton{
    ZYDropDownMenu *menu=[[ZYDropDownMenu alloc]init];
    menu.delegate=self;
    ZYDropController *vc=[[ZYDropController alloc]init];
    vc.view.height=150;
    vc.view.width=150;
    menu.contentController=vc;
    [menu showFrom:titleButton];


}

- (void)dropdownMenuDidDismiss:(ZYDropDownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;


}

- (void)dropdownMenuDidShow:(ZYDropDownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;


}

-(void)friendSearch{
NSLog(@"friendSearch");
}

-(void)pop{

NSLog(@"pop");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.wbMdls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     ZYTwCellTableViewCell *cell = [ZYTwCellTableViewCell cellWithTableView:tableView];
    cell.statusFrame = self.wbMdls[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYStatusFrame *frame = self.wbMdls[indexPath.row];
    return frame.cellHeight;
}

@end
