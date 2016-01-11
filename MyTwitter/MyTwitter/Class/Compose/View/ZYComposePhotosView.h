//
//  ZYComposePhotosView.h
//  MyTwitter
//
//  Created by apple on 16/1/7.
//  Copyright (c) 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYComposePhotosView : UIView
@property (nonatomic, strong, readonly) NSMutableArray *photos;
- (void)addPhoto:(UIImage *)photo;

@end
