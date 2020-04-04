//
//  NSString+XJStringUitls.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "NSString+XJStringUitls.h"

@implementation NSString (XJStringUitls)


+(NSString *)timeStampConversionNSString:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)dateConversionTimeStamp:(NSDate *)date
{
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}


+(NSDate *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

+ (NSString *)constellation:(NSDate *)birthday
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    NSInteger m = [birthday month];
    NSInteger d = [birthday day];
    
    if (m < 1 || m > 12 || d <1 || d > 31) {
        return @"";
    }
    
    if( m ==2 && d > 29) {
        return @"";
        
    }else if(m == 4 || m == 6 || m==9 || m==11) {
        if ( d > 30) {
            return @"";
        }
    }
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return [result stringByAppendingString:@"座"];
    
}
+ (NSString *)dateToString:(NSDate *)date{
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.dateFormat = @"yyyy-MM-dd";
    
    NSString *string = [format stringFromDate:date];
    
    return string;
}

//改变指定label字体颜色和大小
+ (NSMutableAttributedString *)changeStringColorAndFontWithOldStr:(NSString *)oldStr changeStr:(NSString *)changeStr color:(UIColor *)color font:(UIFont *)font{
    
    long len2 = [changeStr length];
    long len1 = [oldStr length];
    NSString *str3 = [NSString stringWithFormat:@"%@ %@",oldStr,changeStr];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str3];
    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(len1+1,len2)];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(len1+1,len2)];
    return string;
}

+ (CGFloat)findWidthForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGFloat result = font.pointSize + 4;
    if (text)
    {
        CGSize textSize = { widthValue, CGFLOAT_MAX };       //Width and height of text area
        CGSize size;
        //iOS 7
        CGRect frame = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:font }
                                          context:nil];
        size = CGSizeMake(frame.size.width + 1, frame.size.height);
        result = MAX(size.width, result); //At least one row
    }
    return result;
}

- (BOOL)isEmptyOrWhitespace {
    // A nil or NULL string is not the same as an empty string
    return 0 == self.length ||
           ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

+ (BOOL)isBlank:(NSString *)str {
    return str == nil || [str isEmptyOrWhitespace];
}

+ (BOOL)isNotBlank:(NSString *)str {
    return ![NSString isBlank:str];
}

+ (BOOL)isNumeric:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSInteger hold;
    if ([scanner scanInteger:&hold] && [scanner isAtEnd]) return YES;
    return NO;
}



@end
