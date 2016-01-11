#import "NSString+test.h"
#import "ZYEmotion.h"
#import "MJExtension.h"
#import <UIKit/UIKit.h>
@implementation NSString (test)
+(NSMutableAttributedString *)stringToAttributeString:(NSString *)text
{
    //先把普通的字符串text转化生成Attributed类型的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    NSString * zhengze = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"; //正则表达式 ,例如[呵呵] 这种形式的通配符
    
    NSError * error;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:&error];//正则表达式
    if (!re)
    {
        NSLog(@"%@",[error localizedDescription]);//打印错误
    }
    
    NSArray * arr = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];//遍历字符串,获得所有的匹配字符串
    NSString *path = [[NSBundle mainBundle] pathForResource:@"default.plist" ofType:nil];
    NSMutableArray *arrM=[NSMutableArray array];
    NSArray *arrD=[ZYEmotion objectArrayWithKeyValuesArray:[NSMutableArray arrayWithContentsOfFile:path]];
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"lxh.plist" ofType:nil];
    NSArray *arrL = [ZYEmotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path1]];
    
    
    [arrM addObjectsFromArray:arrD];
    [arrM addObjectsFromArray:arrL];
    
    //如果有多个表情图，必须从后往前替换，因为替换后Range就不准确了
    for (int j =(int) arr.count - 1; j >= 0; j--) {
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult * result = arr[j];
        
        for (int i = 0; i < arrM.count; i++) {
            ZYEmotion *emotion=arrM[i];
            if ([[text substringWithRange:result.range] isEqualToString:emotion.chs])//从数组中的字典中取元素
            {
                NSString * imageName = [NSString stringWithString:emotion.png];
                
                NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];//添加附件,图片
                
                textAttachment.image = [UIImage imageNamed:imageName];
                
                CGFloat attchWH = 20;
                textAttachment.bounds = CGRectMake(0, -4, attchWH, attchWH);

                
                NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                [attStr replaceCharactersInRange:result.range withAttributedString:imageStr];//替换未图片附件
//                NSLog(@"%@",attStr);
                break;
            }
        }
    }
    return attStr;
}

@end
