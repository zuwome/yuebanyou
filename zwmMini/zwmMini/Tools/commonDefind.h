//
//  commonDefind.h
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#ifndef commonDefind_h
#define commonDefind_h

typedef NS_ENUM(NSInteger,NavigationType) {
    NavigationTypeGotoCenter = 0,    // 点击头像人脸检测完成要进入-我
    NavigationTypeRealname,          // 点击实名认证完成要进入 人脸检测
    NavigationTypeRent,              // 点击我要出租 认证完成要进入我的出租
    NavigationTypeUserLogin,         // 公众号账号登录和注册过来
    NavigationTypeUserCenter,        // 我那边修改图片 提示语要不同
    NavigationTypeNoPhotos,          // 首页过来没有人脸检测并且没有头像
    NavigationTypeHavePhotos,        // 首页过来没有人脸检测但有头像
    NavigationTypeAccountCancel,     // 账号注销
    NavigationTypeChangePhone,       // 修改手机号
    NavigationTypeRestartPhone,      // 重新启用手机号
    NavigationTypeChangePwd,         // 修改密码
    
    NavigationTypeUserInfo,          // 保存用户信息
//    NavigationTypeUserInfo,          // 保存用户信息
    NavigationTypeChat,              // 他人详情页点击聊天需要完善人脸/头像
    NavigationTypeFastChat,
    NavigationTypeOrder,             // 他人详情页点击马上预约需要完善人脸/头像
    NavigationTypeApplyTalent,       // 我的-申请达人需要完善人脸/头像
    NavigationTypeWeChat,            // 我的-我的微信需要完善人脸/头像
    NavigationTypeIDPhoto,           // 我的-我的证件照需要完善人脸/头像
    NavigationTypeRealName,          // 我的-实名认证需要完善人脸/头像
    NavigationTypeCashWithdrawal,    // 我的钱包-提现 需要完善人脸/头像
    NavigationTypeSnatchOrder,       // 闪租抢单 需要完善人脸/头像
    NavigationTypeSelfIntroduce,     // 编辑资料-达人视频 需要完善人脸/头像
    NavigationTypeOpenFastChat ,     // 闪聊-申请开通 需要完善人脸/头像
    NavigationTypeTiXian  ,          // 提现- 银行卡
    NavigationTypeDevicesLoginFirst,  // 设备首次登录
    NavigationTypePublishTask,
    
    NavigationTypeSignUpForTask,     // 报名
    NavigationTypeUnknow = -1,       // unknow
};



#define RegisterRentUrl @"http://static.zuwome.com/rent/apply.html"
#define RentCompleteUrl @"/rent/rentinfo"

//Tabbar 高度
#define TABBAR_HEIGHT               (kScreenHeight == 812.0 ? 83 : 49)

//当前订单的支付数据（用于验证支付结果）
#define kPaymentData    @"kPaymentData"

#define REMOVE_MSG(STRID)       [[NSNotificationCenter defaultCenter] removeObserver:self name:STRID object:nil];
#define REMOVE_ALL_MSG()        [[NSNotificationCenter defaultCenter] removeObserver:self]

/**
 * 生成 commonInit 方法
 */
#define commonInitSafe(className)                   [self className ## _commonInit]
#define commonInitImplementationSafe(className)     -(void) className##_commonInit

#define INT_TO_STRING(i)        [NSString stringWithFormat:@"%zd",i]
#define DOUBLE_TO_STRING(i)        [NSString stringWithFormat:@"%f",i]

/**
 * 通知相关
 */
#define BIND_MSG_WITH_OBSERVER(OBSERVER, STRID, SELECTOR, OBJ)   [[NSNotificationCenter defaultCenter] addObserver:OBSERVER  \
selector:SELECTOR      \
name:STRID         \
object:OBJ];

#define BIND_MSG_WITH_OBJ(STRID, SELECTOR, OBJ)     BIND_MSG_WITH_OBSERVER(self, STRID, SELECTOR, OBJ);

#define BIND_MSG(STRID, SELECTOR)                   BIND_MSG_WITH_OBJ(STRID, SELECTOR, nil);


#ifdef DEBUG
#define kQNPrefix_url        @"http://img.movtrip.com/"
#else
#define kQNPrefix_url        @"http://img.zuwome.com/"

#endif

#define kCustomerServiceId          @"KEFU146288374711644"

//自适应字体
#define AdaptedFontSize(R)     CHINESE_SYSTEM(AdaptedWidth(R))
#define ADaptedFontSCBoldSize(R)  [UIFont fontWithName:@"PingFang-SC-Bold" size:R]?[UIFont fontWithName:@"PingFang-SC-Bold" size:R]:[UIFont fontWithName:@"Helvetica-Bold" size:R]
#define ADaptedFontMediumSize(R)  [UIFont fontWithName:@"PingFangSC-Medium" size:R]?[UIFont fontWithName:@"PingFangSC-Medium" size:R]:[UIFont fontWithName:@"Helvetica-Bold" size:R]



#define ADaptedFuturaBoldSize(R)  [UIFont fontWithName:@"Futura-Bold" size:R]?[UIFont fontWithName:@"Futura-Bold" size:R]:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:R]

#define ADaptedFontBoldSize(R)  [UIFont fontWithName:@"PingFangSC-Semibold" size:R]?[UIFont fontWithName:@"PingFangSC-Semibold" size:R]:[UIFont fontWithName:@"Helvetica-Bold" size:R]

#define WEAK_OBJECT(obj, weakObj)       __weak typeof(obj) weakObj = obj;
#define WEAK_SELF()                     WEAK_OBJECT(self, weakSelf);

//通知
#define KMsg_CreateOrderNotification    @"KMsg_CreateOrderNotification" // 创建订单的通知
#define kMsg_UpdateOrder                @"OrderDidUpdateNotification"//更新订单
#define kMsg_OrderStatusChante          @"kUpdateOrderStatus"//订单状态更新
#define kMsg_UserRentInfoDidChanged     @"kMsg_UserRentInfoDidChanged" // 用户出租信息发生变化

/**
 *  安全地调用 block
 */
#define BLOCK_SAFE_CALLS(block, ...) block ? block(__VA_ARGS__) : nil

//自适应宽度
#define AdaptedWidth(x)  ceilf((x)/375.0f * kScreenWidth)
//自适应高度
#define AdaptedHeight(x) ceilf((x)/667.0f * kScreenHeight)

//左键间距
#define kLeftEdgeInset              -11

#define kOrderQuickTimeString       @"尽快"

//判断是否空字符串
#define isNullString(s)     ((!s) || [s isEqual:[NSNull null]] || [s isEqualToString:@""])

//weakself
#define WeakObj(o) autoreleasepool{} __weak typeof(o) weak##o = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = weak##o;

//屏幕宽高
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth   [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width

// 判断是否iPhoneX YES:iPhoneX屏幕 NO:传统屏幕
#define iPhoneX ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? YES : NO )

// 判断iPhone4
#define ISiPhone4       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 960))

// 判断iPhone5
#define ISiPhone5       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(640, 1136))

// 判断iPhone6
#define ISiPhone6       CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(750, 1334))

//判断iPhone6p
#define ISiPhone6P      CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size, CGSizeMake(1242, 2208))

// 判断iOS7 或者7 之后
#define IOS7_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//判断是否是iOS8及以上
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//判断是否是iOS9及以上
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

//判断是否是iOS10及以上
#define IOS10_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

//判断是否是iOS11及以上
#define IOS11_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

// 安全区域
#define SafeAreaTopHeight (iPhoneX ? 88 : 64)
#define SafeAreaBottomHeight (iPhoneX ? 34 : 0)
#define iPhoneXStatusBarHeight (iPhoneX ? 44 : 20)
#define iPhoneTabbarHeight (iPhoneX ? 49 : 49)

//导航栏+状态栏高度navigationBar
#define NAVIGATIONBAR_HEIGHT        (kScreenHeight >= 812.0 ? 88 : 64)
//底部圆角宏
#define SafeAreaBottomHeight (kScreenHeight == 812.0 ? 34 : 0)
//状态栏高度 iPhoneX状态栏44
#define STATUSBAR_HEIGHT            (kScreenHeight == 812.0 ? 44 : 20)
//状态栏的bar返回按钮移动高度
#define STATUSBARBar_HEIGHT            (kScreenHeight == 812.0 ? 12 : 0)
//顶部状态栏新增加高度
#define STATUSBARBar_ADD_HEIGHT            (kScreenHeight == 812.0 ? 48 : 32)
//顶部距离导航中心的距离偏移
#define STATUSBARBar_Center           (kScreenHeight == 812.0 ? 22 : 10)

//判断是否是iOS8及以上
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//判断是否是iOS9及以上
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

//判断是否是iOS11及以上
#define IOS11_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

#define isFullScreenDevice           (kScreenHeight >= 812.0)

#define isFullScreenDevice           (kScreenHeight >= 812.0)

#define isIPhoneX                   (kScreenHeight == 812.0)

#define isIPhoneXsMax                   (kScreenHeight == 896.0)

//颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
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

// 背景色
#define kBGColor                HEXCOLOR(0xF5F5F5)

// 黑色文字
#define kBlackTextColor         HEXCOLOR(0x000000)

/// 黑色文字  63 58 58
#define kBlackColor             HEXCOLOR(0x3f3a3a)

// 灰色文字
#define kGrayTextColor          HEXCOLOR(0xababab)

//深灰色文字
#define kGrayContentColor       HEXCOLOR(0x808080)

//评论灰色字(7A7A7B)
#define kGrayCommentColor       HEXCOLOR(0x7A7A7B)

//灰色的线
#define kGrayLineColor          HEXCOLOR(0xD8D8D8)

//灰色线颜色
#define kLineViewColor          HEXCOLOR(0xededed)

//黄色
#define kYellowColor            HEXCOLOR(0xF4CB07)

//红色
#define kRedColor               HEXCOLOR(0xF42407)
#define kUploadRedColor         HEXCOLOR(0xec0005)

//红色字体
#define kRedTextColor           HEXCOLOR(0xFD5F66)

//红点颜色
//#define kRedPointColor          HEXCOLOR(0xF32426)
#define kRedPointColor          HEXCOLOR(0xFA595A)

//蓝色颜色
#define kBlueColor              HEXCOLOR(0xF32426)

//棕灰色   rgb:102, 102, 102
#define kBrownishGreyColor      HEXCOLOR(0x666666)

//日光黄   rgb:255, 223, 54
#define kSunYellow              HEXCOLOR(0xFFDF36)

//金菊色
#define kGoldenRod              HEXCOLOR(0xF0C20D)

//rgb:252, 47, 82
#define kReddishPink            HEXCOLOR(0xFC2F52)

//Warm Gray rgb:153, 153, 153
#define kWarmGray               HEXCOLOR(0x999999)

//石板灰   rgb:230, 230, 230
#define kStoneGray              HEXCOLOR(0xE6E6E6)


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

#define  IOS_11_Show   if (@available(iOS 11.0, *)) {\
[UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;\
[UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;\
[UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;\
}

#define  IOS_11_NO_Show   if (@available(iOS 11.0, *)) {\
[UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
[UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
[UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
}

typedef NS_ENUM(NSInteger, ShowHUDType) {
    ShowHUDType_OpenSanChat =100,//开通闪聊的提示
    ShowHUDType_OpenRentSuccess,//开通闪租的提示
};

#endif /* commonDefind_h */
