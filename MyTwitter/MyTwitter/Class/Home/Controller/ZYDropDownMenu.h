//
//  ZYDropDownMenu.h
//  MyTwitter
//
//  Created by apple on 15/12/28.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYDropDownMenu;
@protocol ZYDropDownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(ZYDropDownMenu *)menu;
- (void)dropdownMenuDidShow:(ZYDropDownMenu *)menu;


@end
@interface ZYDropDownMenu : UIView
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic, weak) id<ZYDropDownMenuDelegate> delegate;
+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

@end
