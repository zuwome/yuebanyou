//
//  XJRequestManager.m
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRequestManager.h"
#import "AFNetworking.h"
#import "XJLoginVC.h"
#import "XJNaviVC.h"
#import "UIViewController+XJShowSeletcController.h"
#import "HttpDNS.h"
#import "NSURL+XJUtils.h"

@interface XJRequestManager ()

@property(nonatomic,strong) NSMutableDictionary *phoneDic;
@property(nonatomic,copy) NSString *currentUrl;
@property(nonatomic,strong) NSMutableDictionary *currentParmas;

@end

@implementation XJRequestManager

static XJRequestManager *Request = nil;

+(XJRequestManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (Request == nil) {
            Request = [[self alloc]init];
        }
    });
    return Request;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (Request == nil) {
            Request = [super allocWithZone:zone];
        }
    });
    return Request;
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    return Request;
    
}
- (void)GET:(NSString *)URLString dict:(NSMutableDictionary *)params succeed:(void (^)(id data,XJRequestError *rError))succeed failure:(void (^)(NSError *error))failure
{
    

        //创建网络请求管理对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.securityPolicy setAllowInvalidCertificates:YES];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //如果报接受类型不一致替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/png",nil];
        if (!NULLString(XJUserAboutManageer.access_token)) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",XJUserAboutManageer.access_token] forHTTPHeaderField:@"X-Api-Token"];
        }
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        // 是否允许,NO-- 不允许无效的证书
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        //设置证书
        [securityPolicy setPinnedCertificates:certSet];
        manager.securityPolicy = securityPolicy;
        
        NSString *urlstr = [NSString stringWithFormat:@"%@%@?dev=%@&dev_name=%@&dev_version=%@&v=%@&app_sid=yby&yv=%@",APIBASE,URLString, self.phoneDic[@"dev"], self.phoneDic[@"dev_name"], self.phoneDic[@"dev_version"], self.phoneDic[@"v"],self.phoneDic[@"dev_version"]];
        if (!NULLString(XJUserAboutManageer.access_token)) {
            params[@"access_token"] = XJUserAboutManageer.access_token;
        }
    
        //发送网络请求(请求方式为GET)
        [manager GET:urlstr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSLog(@"===%@",responseObject);
    //        NSLog(@"%@",[responseObject allKeys]);
            BOOL isData = NO;
        
            if ([[responseObject allKeys] containsObject:@"data"]) {
                isData = YES;
            }
            if (isData) {
                succeed(responseObject[@"data"],nil);
            }
            else {
                
                XJRequestError *errorModel = [XJRequestError yy_modelWithDictionary:responseObject[@"error"]];
                NSLog(@"error ==%@---",responseObject[@"error"]);
                succeed(responseObject,errorModel);
                
                switch (errorModel.code) {
                    case 4034: {
                        // 登录过期
                        UIViewController *currVC = [self getCurrentVC];
                        if ([currVC isMemberOfClass:[XJLoginVC class]]) {
                            break ;

                        }
                        NSLog(@"需要重新登录");

    //                    [currVC showAlerVCtitle:@"提示" message:@"登录已过期请重新登录" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                            [XJUserAboutManageer managerRemoveUserInfo];
                            [[XJRongIMManager sharedInstance] logOutRongIM];
                            XJLoginVC *loginV = [[XJLoginVC alloc] init];
                            XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:loginV];
                            ([UIApplication sharedApplication].delegate).window.rootViewController=nav;
    //                    } cancelBlock:^{
    //
    //                    }];
                        break;
                    }
                    case 4044: {
                        break;
                    }
                    case 4045: {
                        break;
                    }
                    case 8000: {
                        break;
                    }
                    default: {
                        [MBManager showBriefAlert:errorModel.message];
                        break;
                    }
                        
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            NSLog(@"error is %@", error);
        }];
    
//    NSURL *backendURL = [[NSURL alloc] initWithString:APIBASE];
//
//    // 获取IP
//    [[HttpDNS shareInstance] getIpByHost:backendURL.host next:^(NSError *error, NSString *ip) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *newHost = error? backendURL.host: ip;//当欠费的时候IP 返回的是一串的乱码  这个时候会崩溃的
//
//                    //创建网络请求管理对象
//                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//                    //申明返回的结果是json类型
//                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//                    [manager.securityPolicy setAllowInvalidCertificates:YES];
//
//                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//                    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",self.phoneDic[@"uuid"]] forHTTPHeaderField:@"uuid"];
//                    //如果报接受类型不一致替换一致text/html或别的
//                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/png",nil];
//
//                    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
//                    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//                    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//                    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//                    // 是否允许,NO-- 不允许无效的证书
//                    securityPolicy.allowInvalidCertificates = YES;
//                    securityPolicy.validatesDomainName = NO;
//                    //设置证书
//                    [securityPolicy setPinnedCertificates:certSet];
//                    manager.securityPolicy = securityPolicy;
//
//                    if (!NULLString(XJUserAboutManageer.access_token)) {
//                        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",XJUserAboutManageer.access_token] forHTTPHeaderField:@"X-Api-Token"];
//                    }
//
//                    NSString *api = nil;
//                    NSString *sURL = [NSString stringWithFormat:@"%@://%@", backendURL.scheme,newHost];
//                    if (backendURL.port) {
//                        sURL = [sURL stringByAppendingString:[NSString stringWithFormat:@":%@", backendURL.port]];
//                    }
//                    sURL = [sURL stringByAppendingFormat:@"/%@",URLString];
//                    NSURL *URL = [[NSURL alloc] initWithString:sURL];
//                    if (!URL) {
//                        sURL = [NSString stringWithFormat:@"%@://%@", backendURL.scheme,backendURL.host];
//                        URL = [[NSURL alloc] initWithString:sURL];
//
//                    }
//                    api = [URL absoluteString];
//
//                    NSString *urlstr = [NSString stringWithFormat:@"%@?dev=%@&dev_name=%@&dev_version=%@&v=%@&app_sid=yby&yv=%@",api, self.phoneDic[@"dev"], self.phoneDic[@"dev_name"], self.phoneDic[@"dev_version"], self.phoneDic[@"v"],self.phoneDic[@"dev_version"]];
//                    if (!NULLString(XJUserAboutManageer.access_token)) {
//                        params[@"access_token"] = XJUserAboutManageer.access_token;
//                    }
//                    //发送网络请求(请求方式为GET)
//                    [manager GET:urlstr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//
//                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                //        NSLog(@"===%@",responseObject);
//                //        NSLog(@"%@",[responseObject allKeys]);
//                        BOOL isData = NO;
//
//                        if ([[responseObject allKeys] containsObject:@"data"]) {
//                            isData = YES;
//                        }
//                        if (isData) {
//                            succeed(responseObject[@"data"],nil);
//                        }
//                        else {
//
//                            XJRequestError *errorModel = [XJRequestError yy_modelWithDictionary:responseObject[@"error"]];
//                            NSLog(@"error ==%@---",responseObject[@"error"]);
//                            succeed(responseObject,errorModel);
//                            switch (errorModel.code) {
//                                case 4034: {
//                                    // 登录过期
//                                    UIViewController *currVC = [self getCurrentVC];
//                                    if ([currVC isMemberOfClass:[XJLoginVC class]]) {
//                                        break ;
//                                    }
//                                    NSLog(@"需要重新登录");
//
//                //                    [currVC showAlerVCtitle:@"提示" message:@"登录已过期请重新登录" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
//                                        [XJUserAboutManageer managerRemoveUserInfo];
//                                        [[XJRongIMManager sharedInstance] logOutRongIM];
//                                        XJLoginVC *loginV = [[XJLoginVC alloc] init];
//                                        XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:loginV];
//                                        ([UIApplication sharedApplication].delegate).window.rootViewController=nav;
//                //                    } cancelBlock:^{
//                //
//                //                    }];
//                                    break;
//                                }
//                                case 4044: {
//                                    break;
//                                }
//                                case 4045: {
//                                    break;
//                                }
//                                case 8000: {
//                                    break;
//                                }
//                                default: {
//                                    [MBManager showBriefAlert:errorModel.message];
//                                    break;
//                                }
//
//                            }
//                        }
//                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        failure(error);
//                        NSLog(@"error is %@", error);
//                    }];
//        });
//
//    }];
}

- (void)specailPOST:(NSString *)URLString dict:(NSMutableDictionary *)params succeed:(void (^)(id data, XJRequestError *rError))succeed failure:(void (^)(NSError *error))failure {
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/png",nil];

    if (!NULLString(XJUserAboutManageer.access_token)) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",XJUserAboutManageer.access_token] forHTTPHeaderField:@"X-Api-Token"];
    }
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    // 是否允许,NO-- 不允许无效的证书
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    //设置证书
    [securityPolicy setPinnedCertificates:certSet];
    manager.securityPolicy = securityPolicy;

    NSString *urlstr = [NSString stringWithFormat:@"%@%@?dev=%@&dev_name=%@&dev_version=%@&v=%@&app_sid=yby&yv=%@",APIBASE,URLString, self.phoneDic[@"dev"], self.phoneDic[@"dev_name"], self.phoneDic[@"dev_version"], self.phoneDic[@"v"],self.phoneDic[@"dev_version"]];
    if (!NULLString(XJUserAboutManageer.access_token)) {
        params[@"access_token"] = XJUserAboutManageer.access_token;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [manager POST:urlstr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"===%@",responseObject);

        BOOL isData = NO;
        if ([[responseObject allKeys] containsObject:@"data"]) {
            isData = YES;
            
        }
        if (isData) {
            
            succeed(responseObject[@"data"],nil);
            
        }else{
            
            
            XJRequestError *errorModel = [XJRequestError yy_modelWithDictionary:responseObject[@"error"]];
            NSLog(@"error ==%@---",responseObject[@"error"]);
            succeed(responseObject,errorModel);
       
            
            switch (errorModel.code) {
                case 4030: {
                    [MBManager showBriefAlert:errorModel.message];
                }
                    break;
                    //登录过期
               case 4034:
                   {
                       
                       UIViewController *currVC = [self getCurrentVC];
                       if ([currVC isMemberOfClass:[XJLoginVC class]]) {
                           break ;
                       }
                       NSLog(@"需要重新登录");

//                       [currVC showAlerVCtitle:@"提示" message:@"登录已过期请重新登录" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                           [XJUserAboutManageer managerRemoveUserInfo];
                           [[XJRongIMManager sharedInstance] logOutRongIM];

                           XJLoginVC *loginV = [[XJLoginVC alloc] init];
                           XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:loginV];
                           ([UIApplication sharedApplication].delegate).window.rootViewController=nav;
//                       } cancelBlock:^{
//
//                       }];
                   }
                    break;
                case 4044:
                {
                    
                }
                    break;
                case 4045:
                {
                
                    
                }
                    break;
                case 8000:
                {
                   
                }
                    break;
                
                    
                default:{
                    [MBManager showBriefAlert:errorModel.message];

                }
                    break;
            }
            
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        failure(error);
        
    }];
        
}


- (void)POST:(NSString *)URLString dict:(NSMutableDictionary *)params succeed:(void (^)(id data, XJRequestError *rError))succeed failure:(void (^)(NSError *error))failure {
    //创建网络请求管理对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //申明返回的结果是json类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.securityPolicy setAllowInvalidCertificates:YES];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //如果报接受类型不一致替换一致text/html或别的
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/png",nil];
        
        if (!NULLString(XJUserAboutManageer.access_token)) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",XJUserAboutManageer.access_token] forHTTPHeaderField:@"X-Api-Token"];
        }
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    // 是否允许,NO-- 不允许无效的证书
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    //设置证书
    [securityPolicy setPinnedCertificates:certSet];
    manager.securityPolicy = securityPolicy;
    
       NSString *urlstr = [NSString stringWithFormat:@"%@%@?dev=%@&dev_name=%@&dev_version=%@&v=%@&app_sid=yby&yv=%@",APIBASE,URLString, self.phoneDic[@"dev"], self.phoneDic[@"dev_name"], self.phoneDic[@"dev_version"], self.phoneDic[@"v"],self.phoneDic[@"dev_version"]];
        if (!NULLString(XJUserAboutManageer.access_token)) {
            params[@"access_token"] = XJUserAboutManageer.access_token;
        }
        [manager POST:urlstr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
    //        NSLog(@"===%@",responseObject);

            BOOL isData = NO;
            if ([[responseObject allKeys] containsObject:@"data"]) {
                isData = YES;
                
            }
            if (isData) {
                
                succeed(responseObject[@"data"],nil);
                
            }else{
                
                
                XJRequestError *errorModel = [XJRequestError yy_modelWithDictionary:responseObject[@"error"]];
                NSLog(@"error ==%@---",responseObject[@"error"]);
                succeed(responseObject,errorModel);
           
                
                switch (errorModel.code) {
                    case 4030: {
                        [MBManager showBriefAlert:errorModel.message];
                    }
                        break;
                        //登录过期
                   case 4034:
                       {
                           
                           UIViewController *currVC = [self getCurrentVC];
                           if ([currVC isMemberOfClass:[XJLoginVC class]]) {
                               break ;
                           }
                           NSLog(@"需要重新登录");

    //                       [currVC showAlerVCtitle:@"提示" message:@"登录已过期请重新登录" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                               [XJUserAboutManageer managerRemoveUserInfo];
                               [[XJRongIMManager sharedInstance] logOutRongIM];

                               XJLoginVC *loginV = [[XJLoginVC alloc] init];
                               XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:loginV];
                               ([UIApplication sharedApplication].delegate).window.rootViewController=nav;
    //                       } cancelBlock:^{
    //
    //                       }];
    //
                           
                          
                       }
                        break;
                    case 4044:
                    {
                        
                    }
                        break;
                    case 4045:
                    {
                    
                        
                    }
                        break;
                    case 8000:
                    {
                       
                    }
                        break;
                    
                        
                    default:{
                        [MBManager showBriefAlert:errorModel.message];

                    }
                        break;
                }
                
            }

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            failure(error);
            
        }];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}



- (NSMutableDictionary *)phoneDic{
    if (!_phoneDic) {
        _phoneDic = @{}.mutableCopy;
        _phoneDic[@"dev"] = @"ios";
        _phoneDic[@"dev_name"] = [[XJUtils deviceVersion] stringByReplacingOccurrencesOfString:@" "  withString:@""];
        _phoneDic[@"dev_version"] = [XJUtils phoneVersion];
        _phoneDic[@"v"] = [XJUtils bundleVersion];
        _phoneDic[@"uuid"] =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
    }
    return _phoneDic;
}


@end


@implementation XJRequestError



@end
