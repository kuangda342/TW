//
//  ZYEmotionTool.h
//  MyTwitter
//
//  Created by apple on 16/1/6.
//  Copyright (c) 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYEmotion;
@interface ZYEmotionTool : NSObject
+ (void)addRecentEmotion:(ZYEmotion *)emotion;
+ (NSArray *)recentEmotions;

@end
