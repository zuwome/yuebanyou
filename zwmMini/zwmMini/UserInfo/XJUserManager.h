//
//  XJUserManager.h
//  zwmMini
//
//  Created by Batata on 2018/11/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJUserModel.h"
#import "XJSystemCofigModel.h"
#import "XJUnreadModel.h"
#import "ZZCacheOrder.h"

NS_ASSUME_NONNULL_BEGIN

#define XJUserAboutManageer  [XJUserManager sharedInstance]

@interface XJUserManager : NSObject

@property (nonatomic, assign) BOOL shouldChangeAppTips;

//face++
@property (assign, nonatomic) BOOL license;

@property(nonatomic,copy) NSString *qiniuUploadToken;//七牛上传token
@property(nonatomic,copy) NSString *access_token;
@property(nonatomic,assign)BOOL isLogin;//是否登录
@property(nonatomic,copy)NSString *isFirstOpenApp;//是否第一打开app
@property(nonatomic,copy) NSDictionary *provinceCity;//省市区
@property(nonatomic,copy) NSString *cityName; //城市名
@property(nonatomic,copy) NSString *localLongitude;//当前精度
@property(nonatomic,copy) NSString *localLatitude;//当前纬度
@property (assign, nonatomic) BOOL isAbroad;//是否是国外

@property(nonatomic,strong) XJUserModel *uModel;//用户信息
@property(nonatomic,strong) XJSystemCofigModel *sysCofigModel;//系统配置信息
@property(nonatomic,strong) XJUnreadModel *unreadModel;//未读model
@property (nonatomic, strong) XJPriceConfigModel *priceConfig;
@property(nonatomic,copy) NSString *rongTonek;//融云token
@property (strong, nonatomic) NSString *currentChatUid;//正在聊天的对象

@property (strong, nonatomic) ZZCacheOrder *cacheOrder;//订单信息备份

@property (strong, nonatomic) CLLocation *location;

//上次支付方式
@property (strong, nonatomic) NSString *lastPayMethod;


+ (XJUserManager *)sharedInstance;

- (void)managerRemoveUserInfo;

- (BOOL)isUserBanned;

@end

NS_ASSUME_NONNULL_END
