//
//  AppDelegate+setUpServeicesKey.m
//  zwmMini
//
//  Created by Batata on 2018/11/22.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "AppDelegate+setUpServeicesKey.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "APPKeys.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <RongIMKit/RongIMKit.h>
#import "ZZMessageChatWechatPayModel.h"
#import "ZZChatReportModel.h"
//百度face
#import "FaceParameterConfig.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import <UMAnalytics/MobClick.h>

@implementation AppDelegate (setUpServeicesKey)

- (void)setUpKeys {
    
    //高德
    [AMapServices sharedServices].apiKey = GAODE_KEY;
    
    //友盟
    [UMConfigure initWithAppkey:NUMENG_APPKEY channel:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXIN_ID appSecret:WEIXIN_SECRET redirectURL:@"http://mobile.umeng.com/social"];
    
        //友盟统计、自定义事件
    [MobClick setScenarioType:E_UM_NORMAL];
//
    //融云
    NSLog(@"app key is %@", NRONGCLOUD_IM_APPKEY);
    [[RCIM sharedRCIM] initWithAppKey:NRONGCLOUD_IM_APPKEY];
//    [[RCIM sharedRCIM] initWithAppKey:NRONGCLOUD_IM_APPKEY];//正式
//    [[RCIM sharedRCIM] initWithAppKey:NRONGCLOUD_IM_TEST_APPKEY];//测试
    
    [[RCIM sharedRCIM] registerMessageType:[ZZMessageChatWechatPayModel class]];
    [[RCIM sharedRCIM] registerMessageType:[ZZChatReportModel class]];
    
    //连接融云
    if (XJUserAboutManageer.isLogin) {
        [[XJRongIMManager sharedInstance] connectRongIM];
    }
    
    //百度活体检测
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSLog(@"licensePath = %@",licensePath);
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
    NSLog(@"version = %@",[[FaceVerifier sharedInstance] getVersion]);
}

@end
