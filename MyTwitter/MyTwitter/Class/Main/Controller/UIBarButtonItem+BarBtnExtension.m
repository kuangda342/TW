//
//  UIBarButtonItem+BarBtnExtension.m
//  MyTwitter
//
//  Created by apple on 15/12/28.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIBarButtonItem+BarBtnExtension.h"
#import <UIKit/UIKit.h>
#import "UIView+SizeExtension.h"
@implementation UIBarButtonItem (BarBtnExtension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    btn.size=btn.currentBackgroundImage.size;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}
@end
