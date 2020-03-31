//
//  XJRongIMManager.m
//  zwmMini
//
//  Created by Batata on 2018/12/12.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRongIMManager.h"
#import "XJTabBarVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface XJRongIMManager ()<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,RCIMGroupInfoDataSource>



@end


@implementation XJRongIMManager


static XJRongIMManager *RongManager = nil;

+(XJRongIMManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (RongManager == nil) {
            RongManager = [[self alloc]init];

        }
    });
    return RongManager;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (RongManager == nil) {
            RongManager = [super allocWithZone:zone];
        }
    });
    return RongManager;
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    return RongManager;
    
}


- (void)connectRongIM{
    
    [self getUnreadInfo];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    // 本地永久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    NSLog(@"rongtoken = %@",XJUserAboutManageer.rongTonek);
    
    // 连接服务器
    [[RCIM sharedRCIM] connectWithToken:XJUserAboutManageer.rongTonek success:^(NSString *userId) {
        
        NSLog(@"融云登陆成功。当前登录的用户ID: %@", userId);
        RCUserInfo *info = [[RCUserInfo alloc] init];
        info.name = XJUserAboutManageer.uModel.nickname;
        info.userId = XJUserAboutManageer.uModel.uid;
        info.portraitUri = XJUserAboutManageer.uModel.avatar;
        [RCIM sharedRCIM].currentUserInfo = info;
//        [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
        
        
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"融云登陆的错误码为:%ld", (long)status);

        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        
        [self getRongToken];
    }];
    
}


//获取融云token
- (void)getRongToken{
    
    static NSInteger connectCount = 0;
    if (connectCount > 3) {
        connectCount = 0;
        return;
    }
    connectCount += 1;
    [AskManager GET:API_GET_RONGIM_TOKEN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            XJUserAboutManageer.rongTonek = data[@"token"];
            [self connectRongIM];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
//退出融云
- (void)logOutRongIM{
    
    [[RCIM sharedRCIM] logout];

}
- (BOOL)onRCIMCustomAlertSound:(RCMessage *)message
{
    if (![XJUserAboutManageer.currentChatUid isEqualToString:message.targetId]) {
        [self vibrationAndSound];
    }
    return YES;
}

- (void)vibrationAndSound
{
    if (XJUserAboutManageer.uModel.push_config.chat) {
        if (XJUserAboutManageer.uModel.push_config.need_sound) {
            AudioServicesPlaySystemSound(1007);
        }
        if (XJUserAboutManageer.uModel.push_config.need_shake) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
}

//本地推送设置
//- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName
//{
//
//    NSLog(@"PY_在线的情况下走的融云的推送");
//    if (![XJUserAboutManageer.uModel.push_config.push_hide_name) {
//        if (![message.content isKindOfClass:[ZZChatConnectModel class]]) {
//            if ([message.objectName isEqualToString:@"Message_Order"]) {
//                [ZZOrderNotificationHelper localPushNotificationMessage:message];
//                return  YES;
//            }
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.soundName=UILocalNotificationDefaultSoundName;
//            notification.alertBody = @"收到一条新的信息";
//            notification.repeatInterval = 0;
//            notification.userInfo = @{@"rc":@{@"fId":[ZZUserHelper shareInstance].loginer.uid,
//                                              @"tId":message.targetId,
//                                              @"oName":message.objectName,
//                                              @"mId":[NSNumber numberWithLong:message.messageId]}};
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//            return YES;
//        }
//    }
//    return NO;
//}

//
//获取简易用户信息（融云的头像之类得用户自己提供）
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    if (userId) {
        [AskManager GET:API_GET_USERINFO_MINI_(userId) dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:data[@"nickname"] portrait:data[@"avatar"]];
                [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
                completion(user);
                [[NSNotificationCenter defaultCenter] postNotificationName:reloadMessagelisttableviewNotifi object:self];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
//获取未读相关
- (void)getUnreadInfo{
    
    [AskManager GET:API_GET_UNREAD_INFO_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            
            XJUnreadModel *unreadM = [XJUnreadModel yy_modelWithDictionary:data];
            XJUserAboutManageer.unreadModel = unreadM;
            
            [self setUpTabbarUnreadNum];

            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - RCIMReceiveMessageDelegate - 融云实时消息回调
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    [XJChatUtils sharedInstance].unreadNum += 1;
    [self setUpTabbarUnreadNum];
    
    if ([message.content isKindOfClass:[RCCommandMessage class]]) {
        RCCommandMessage *model = (RCCommandMessage *)message.content;
        if (model.data) {
            NSDictionary *aDict = [XJUtils dictionaryWithJsonString:model.data];
            NSInteger type = [[aDict objectForKey:@"type"] integerValue];
            NSLog(@"PY_当前接受_%ld",type);
            NSString *extra = aDict[@"extra"];
            if ([extra isEqualToString:@"banUser"]) {
                NSLog(@"PY_当前已经接受到的融云消息");
                //表示用户被封禁了
                XJBanModel *model = [[XJBanModel alloc]init];
                model.reason = aDict[@"content"];
                XJUserModel *user =  XJUserAboutManageer.uModel;
                user.banStatus = YES;
                user.ban = model;
                XJUserAboutManageer.uModel = user;
                return;
            }
            else if ([extra isEqualToString:@"unbanUser"]) {
                // 解封用户
                NSLog(@"PY_当前已经接受到的融云消息");
                //表示用户被封禁了
                XJBanModel *model = [[XJBanModel alloc]init];
                model.reason = aDict[@"content"];
                XJUserModel *user =  XJUserAboutManageer.uModel;
                user.banStatus = NO;
                user.ban = [XJBanModel new];
                XJUserAboutManageer.uModel = user;
                return;
            }
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:chatVieewReceiveMessagtNoti object:self userInfo:@{@"message":message}];
    
    
}

- (void)setUpTabbarUnreadNumto:(NSInteger)count {
    NSInteger totalUnread = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        XJTabBarVC *tabvc = (XJTabBarVC *)rootViewController;
        UITabBarItem *msgitme =  tabvc.tabBar.items[1];
        if (totalUnread == 0) {
            [msgitme setBadgeValue:nil];
        }
        else {
            [msgitme setBadgeValue:[NSString stringWithFormat:@"%ld",totalUnread]];
        }
    });
}
- (void)setUpTabbarUnreadNum{
    NSInteger totalUnread = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        if ([rootViewController isKindOfClass: [UITabBarController class]]) {
            XJTabBarVC *tabvc = (XJTabBarVC *)rootViewController;
            UITabBarItem *msgitme =  tabvc.tabBar.items[1];
            if (totalUnread > 0) {
                [msgitme setBadgeValue:[NSString stringWithFormat:@"%ld",(long)totalUnread]];
            }
            else {
                [msgitme setBadgeValue:nil];
            }
        }
    });
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    
    
}



@end
