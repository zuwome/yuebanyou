//
//  XJUserManager.m
//  zwmMini
//
//  Created by Batata on 2018/11/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJUserManager.h"

@implementation XJUserManager


static XJUserManager *userManger = nil;

+(XJUserManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (userManger == nil) {
            userManger = [[self alloc]init];
            userManger.shouldChangeAppTips = YES;
        }
    });
    return userManger;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (userManger == nil) {
            userManger = [super allocWithZone:zone];
        }
    });
    return userManger;
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    return userManger;
   
    
}

- (NSString *)qiniuUploadToken
{
    NSString *name = [NSString stringWithFormat:@"qUploadToken"];
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

- (void)setQiniuUploadToken:(NSString *)qiniuUploadToken{
    NSString *name = [NSString stringWithFormat:@"qUploadToken"];
    [[NSUserDefaults standardUserDefaults] setObject:qiniuUploadToken forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)access_token
{
    NSString *name = [NSString stringWithFormat:@"accessToken"];
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

- (void)setAccess_token:(NSString *)access_token{
    NSString *name = [NSString stringWithFormat:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)isLogin{
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"];

}
- (void)setIsLogin:(BOOL)isLogin{
    
        [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"islogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
   
}


- (NSString *)isFirstOpenApp{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"isfirstopenapp"];
    
}
- (void)setIsFirstOpenApp:(NSString *)isFirstOpenApp{
    
    [[NSUserDefaults standardUserDefaults]  setObject:isFirstOpenApp forKey:@"isfirstopenapp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (NSString *)rongTonek{
    
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"rongyuntoken"];

}
- (void)setRongTonek:(NSString *)rongTonek{
    
    [[NSUserDefaults standardUserDefaults]  setObject:rongTonek forKey:@"rongyuntoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSDictionary *)provinceCity{
    
    NSString *name = [NSString stringWithFormat:@"provincecity"];
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}
- (void)setProvinceCity:(NSDictionary *)provinceCity{
    
    NSString *name = [NSString stringWithFormat:@"provincecity"];
    [[NSUserDefaults standardUserDefaults] setObject:provinceCity forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (NSString *)cityName{
    
    NSString *name = [NSString stringWithFormat:@"cityname"];
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}
- (void)setCityName:(NSString *)cityName{
    
    NSString *name = [NSString stringWithFormat:@"cityname"];
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (NSString *)localLongitude{
    NSString *name = [NSString stringWithFormat:@"longitude"];
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}
- (void)setLocalLongitude:(NSString *)localLongitude{
    NSString *name = [NSString stringWithFormat:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:localLongitude forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)localLatitude{
    NSString *name = [NSString stringWithFormat:@"latitude"];
    return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}

- (void)setLocalLatitude:(NSString *)localLatitude{
    NSString *name = [NSString stringWithFormat:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:localLatitude forKey:name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isAbroad{
   return  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isabroad"] boolValue];
}

- (void)setIsAbroad:(BOOL)isAbroad{
    [[NSUserDefaults standardUserDefaults] setBool:isAbroad forKey:@"isabroad"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (XJUserModel *)uModel{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSData *data = [userD objectForKey:@"usermodel"];
    if (data == nil) {
        return nil;
    }
    XJUserModel *model = [XJUserModel yy_modelWithJSON:data];
    return model;
}

- (void)setUModel:(XJUserModel *)uModel{
    NSData *data = [uModel yy_modelToJSONData];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:data forKey:@"usermodel"];
    [userD synchronize];
}

- (void)setSysCofigModel:(XJSystemCofigModel *)sysCofigModel{
    NSData *data = [sysCofigModel yy_modelToJSONData];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:data forKey:@"sysconfigemodel"];
}

- (XJSystemCofigModel *)sysCofigModel{
    NSUserDefaults *sysID = [NSUserDefaults standardUserDefaults];
    NSData *data = [sysID objectForKey:@"sysconfigemodel"];
    if (data == nil) {
        return nil;
    }
    XJSystemCofigModel *model = [XJSystemCofigModel yy_modelWithJSON:data];
    return model;
}

- (void)setUnreadModel:(XJUnreadModel *)unreadModel{
    NSData *data = [unreadModel yy_modelToJSONData];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:data forKey:@"unreadmodel"];
}

- (XJUnreadModel *)unreadModel{
    NSUserDefaults *sysID = [NSUserDefaults standardUserDefaults];
    NSData *data = [sysID objectForKey:@"unreadmodel"];
    if (data == nil) {
        return nil;
    }
    XJUnreadModel *model = [XJUnreadModel yy_modelWithJSON:data];
    return model;
}

- (void)managerRemoveUserInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usermodel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"qUploadToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"islogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"provincecity"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cityname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isabroad"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sysconfigemodel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"rongyuntoken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"unreadmodel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isfirstopenchatview"];
}

- (BOOL)isUserBanned {
    if (self.uModel.banStatus) {
        //        if (self.uModel.ban) {
        //            XJBanModel *model = self.uModel.ban;
        //            [MBManager showBriefAlert:@"你当前处于被封禁状态，无法进行此操作"];
        //            return YES;
        //        }
        [MBManager showBriefAlert:@"你当前处于被封禁状态，无法进行此操作"];
        return YES;
    }
    return NO;
}

- (ZZCacheOrder *)cacheOrder {
    NSString *name = [NSString stringWithFormat:@"usercacheOrder"];
    NSData *objectData = [ZZUserDefaultsHelper objectForDestKey:name];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
}

- (NSString *)lastPayMethod {
    NSString *name = [NSString stringWithFormat:@"lastPayMethod"];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

@end
