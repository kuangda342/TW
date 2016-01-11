#import "ZYDiscoverController.h"
#import "ZYSearchBar.h"
#import "UIView+SizeExtension.h"
@interface ZYDiscoverController ()

@end

@implementation ZYDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZYSearchBar *searchBar=[ZYSearchBar searchBar];
    searchBar.width = 300;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"test-message-%d", (int)indexPath.row];
    
    return cell;
}
@end
