#import <UIKit/UIKit.h>
@class ZYStatusFrame;

@interface ZYTwCellTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ZYStatusFrame *statusFrame;

@end
