#import "TYAttributedLabel+detectHyperLink.h"
#import "TYAttributedLabel.h"
@implementation TYAttributedLabel (detectHyperLink)
+(instancetype)stringToAttributeString:(NSString *)text{
    TYAttributedLabel *bubbleText = [[TYAttributedLabel alloc]init];
    bubbleText.backgroundColor = [UIColor whiteColor];
    bubbleText.layer.borderColor=[UIColor clearColor].CGColor;
    bubbleText.font = [UIFont systemFontOfSize:13];
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text=text;
    bubbleText.characterSpacing=0;

    bubbleText.highlightedLinkColor=[UIColor orangeColor];
    // 提取出文本中的超链接
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:text
                                                options:0
                                                  range:NSMakeRange(0, [text length])];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        NSString *substringForMatch = [text substringWithRange:match.range];
        [attribute addAttribute:(NSString *)kCTFontAttributeName value:(id)bubbleText.font range:match.range];
        [attribute addAttribute:(NSString*)kCTForegroundColorAttributeName
                          value:(id)[[UIColor blueColor] CGColor]
                          range:match.range];
        [bubbleText addLinkWithLinkData:substringForMatch linkColor:[UIColor blueColor] underLineStyle:kCTUnderlineStyleSingle range:match.range];
        TYLinkTextStorage *textrun=[[TYLinkTextStorage alloc]init];
        textrun.linkData=substringForMatch;
[bubbleText.delegate attributedLabel:bubbleText textStorageClicked:textrun atPoint:CGPointZero];
    }
    return bubbleText;
}
@end
