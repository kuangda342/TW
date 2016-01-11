//
//  UIBarButtonItem+BarBtnExtension.h
//  MyTwitter
//
//  Created by apple on 15/12/28.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BarBtnExtension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end
