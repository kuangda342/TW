//
//  ZYUserInfo.m
//  MyTwitter
//
//  Created by apple on 15/12/30.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZYUserInfo.h"

@implementation ZYUserInfo
- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}

@end
