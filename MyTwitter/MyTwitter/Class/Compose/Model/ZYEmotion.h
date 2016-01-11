//
//  ZYEmotion.h
//  MyTwitter
//
//  Created by apple on 16/1/5.
//  Copyright (c) 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYEmotion : NSObject
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的16进制编码 */
@property (nonatomic, copy) NSString *code;
- (BOOL)isEqual:(ZYEmotion *)other;
@end
