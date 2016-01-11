#import <Foundation/Foundation.h>

typedef enum {
    ZYUserVerifiedTypeNone = -1, // 没有任何认证
    
    ZYUserVerifiedPersonal = 0,  // 个人认证
    
    ZYUserVerifiedOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    ZYUserVerifiedOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    ZYUserVerifiedOrgWebsite = 5, // 网站官方：猫扑
    
    ZYUserVerifiedDaren = 220 // 微博达人
} ZYUserVerifiedType;

@interface ZYUserInfo : NSObject
/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;

/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;

/** 认证类型 */
@property (nonatomic, assign) ZYUserVerifiedType verified_type;
@end
