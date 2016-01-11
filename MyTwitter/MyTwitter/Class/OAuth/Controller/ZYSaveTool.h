#import <Foundation/Foundation.h>
@class ZYAccount;
@interface ZYSaveTool : NSObject
+ (void)saveAccount:(ZYAccount *)account;
+ (ZYAccount *)account;

@end
