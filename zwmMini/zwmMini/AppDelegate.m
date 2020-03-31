//
//  AppDelegate.m
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+setUpUIs.h"
#import "AppDelegate+setUpServeicesKey.h"
#import "XJTabBarVC.h"
#import <UMShare/UMShare.h>
#import "XJGuidPageVC.h"
#import "XYIAPKit.h"
#import "XYStoreiTunesReceiptVerifier.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setupApperance];
    
    // 加载第三方Keys
    [self setUpKeys];
    
    // 小红点
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeRoot)
                                                 name:changeRootVCNotifi object:nil];
    
    // 生成跟控制器
    if (NULLString(XJUserAboutManageer.isFirstOpenApp)) {
        self.window.rootViewController = [[XJGuidPageVC alloc] init];
        [self.window makeKeyWindow];

    }else{
        self.window.rootViewController = [[XJTabBarVC alloc] init];
        [self.window makeKeyWindow];
    }
   
    //授权通知
    [self setUpPushMessage];
    
    // 在此设置内购的票据校验，防止掉单问题的发生
    [[XYStore defaultStore] registerReceiptVerifier:[XYStoreiTunesReceiptVerifier shareInstance]];
    return YES;
}

- (void)changeRoot{
    self.window.rootViewController = [[XJTabBarVC alloc] init];
    [self.window makeKeyWindow];
}

// 授权通知
- (void)setUpPushMessage{
    UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
        [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 获取到推送吧
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // userInfo为远程推送的内容
    NSLog(@" 远程推送的内容 =%@",userInfo);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//ios9以上
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        
    }
    return result;
}


@end
