#import "TTTAttributedLabel+detectHyperLink.h"
@implementation TTTAttributedLabel (detectHyperLink)
+(instancetype)stringToAttributeString:(NSString *)text{
    TTTAttributedLabel *bubbleText = [[TTTAttributedLabel alloc]
                                      initWithFrame:CGRectMake(27.0f, 20.0f, 27.f,20.f)];
    
    bubbleText.backgroundColor = [UIColor clearColor];
    
    bubbleText.font = [UIFont systemFontOfSize:14];
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    bubbleText.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                                  (NSString*)kCTForegroundColorAttributeName : (id)[[UIColor blueColor] CGColor]};
    
    bubbleText.highlightedTextColor = [UIColor whiteColor];
    bubbleText.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
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
        [bubbleText addLinkToURL:[NSURL URLWithString:substringForMatch] withRange:match.range];
        [bubbleText.delegate attributedLabel:bubbleText didSelectLinkWithURL:[NSURL URLWithString:substringForMatch]];
    }
    return bubbleText;


}
@end
