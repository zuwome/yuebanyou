//
//  commonDefind.h
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#ifndef commonDefind_h
#define commonDefind_h



//weakself
#define WeakObj(o) autoreleasepool{} __weak typeof(o) weak##o = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = weak##o;

//屏幕宽高
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width

// 判断是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define iPhoneX ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? YES : NO )
// 安全区域
#define SafeAreaTopHeight (iPhoneX ? 88 : 64)
#define SafeAreaBottomHeight (iPhoneX ? 34 : 0)
#define iPhoneXStatusBarHeight (iPhoneX ? 44 : 20)
#define iPhoneTabbarHeight (iPhoneX ? 49 : 49)

//判断是否是iOS8及以上
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//判断是否是iOS9及以上
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

//判断是否是iOS11及以上
#define IOS11_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

//颜色
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
// 十六进制颜色设置
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//租我吗颜色
#define kYellowColor            HEXCOLOR(0xF4CB07)
#define ZWM_YELLOW @"#F4CB07"



#define defaultBlack RGB(51, 51, 51)
#define defaultGray RGB(153, 153, 153)
#define defaultWhite [UIColor whiteColor]
#define defaultLineColor RGB(240, 240, 240)
#define defaultClearColor [UIColor clearColor]
#define defaultRedColor RGB(254, 83, 108)



//字体
#define defaultFont(font) [UIFont systemFontOfSize:font]


//判断字符串是否为空
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

#define GetImage(name) [UIImage imageNamed:name]


//=====================单例==================
// @interface
#define singleton_interface(className) \
+ (className *)shared;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
static dispatch_once_t singleton_onceToken; \
static dispatch_once_t singleton_share_onceToken; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
dispatch_once(&singleton_onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared \
{ \
dispatch_once(&singleton_share_onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
#endif /* commonDefind_h */
