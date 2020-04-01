//
//  NSString+XJStringUitls.h
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XJStringUitls)

//时间戳转字符串
+(NSString *)timeStampConversionNSString:(NSString *)timeStamp;
//时间转时间戳
+(NSString *)dateConversionTimeStamp:(NSDate *)date;
//字符串转时间
+(NSDate *)nsstringConversionNSDate:(NSString *)dateStr;
//判断星座
+ (NSString *)constellation:(NSDate *)birthday;
//时间转字符串
+ (NSString *)dateToString:(NSDate *)date;

//改变指定label字体颜色和大小
+ (NSMutableAttributedString *)changeStringColorAndFontWithOldStr:(NSString *)oldStr changeStr:(NSString *)changeStr color:(UIColor *)color font:(UIFont *)font;

+ (CGFloat)findWidthForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
