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

/**
 *  MARK: 用户头像审核中，是否可以显示旧头像
 */
- (BOOL)canShowUserOldAvatarWhileIsManualReviewingg:(XJUserModel *)user {
    if ([self isUsersAvatarManuallReviewing:user] && user.old_avatar.length > 0) {
        return YES;
    }
    return NO;
}

/**
 *  MARK: 用户头像是否在审核中
 */
- (BOOL)isUsersAvatarManuallReviewing:(XJUserModel *)user {
    return user.avatar_manual_status == 1;
}

/**
 *  MARK: 余额记录（分页）
 */
+ (void)getUserBalanceRecordWithParam:(NSDictionary *)param next:(requestCallback)next {
    [AskManager GET:[NSString stringWithFormat:@"api/user/capital2"] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (next) {
            next(rError, data, nil);
        }
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/capital2"] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        if (next) {
//            next(error, data, task);
//        }
//    }];
}

/**
 * MARK: 检测文本是否违规
 * type: 1个人签名 2昵称 3公开么么答 4私信么么答 5技能介绍
 */
+ (void)checkTextWithText:(NSString *)text
                     type:(NSInteger)type
                     next:(requestCallback)next {
    [AskManager POST:@"system/text_detect" dict:@{@"content":text,@"type":[NSNumber numberWithInteger:type]}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (next) {
            next(rError, data, nil);
        }
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:@"/system/text_detect" params:@{@"content":text,@"type":[NSNumber numberWithInteger:type]} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        if (next) {
//            next(error, data, task);
//        }
//    }];
}

#pragma mark 活体
/**
 *  MARK: 是否拥有活体
 */
- (BOOL)didHaveRealFace {
    // 活体
    if (self.uModel.faces.count != 0) {
        return YES;
    }
    return NO;
}

#pragma mark 真实头像
/**
 *  MARK: 是否拥有真实头像
 */
- (BOOL)didHaveRealAvatar {
    XJPhoto *photo = self.uModel.photos_origin.firstObject;
    if (photo && photo.face_detect_status == 3) {
        return YES;
    }
    return NO;
}

/**
 *  MARK: 头像是否在审核中
 */
- (BOOL)isAvatarManualReviewing {
    return self.uModel.avatar_manual_status == 1;
}


/**
 *  MARK: 身份信息不完整不能继续的action
 */
- (void)cantProceedAction:(NSInteger)incompleteType
                    title:(NSString *)title
                  message:(NSString *)message
                     done:(NSString *)doneTitle
              cancelTitle:(NSString *)cancelTitle
                    block:(void (^)(BOOL success, NavigationType type, BOOL isCancel))block {
    [UIAlertController presentAlertControllerWithTitle:title
                                               message:message
                                             doneTitle:doneTitle
                                           cancelTitle:cancelTitle
                                         completeBlock:^(BOOL isCancelled) {
        if (block) {
            block(NO, incompleteType, isCancelled);
        }
    }];
}

/**
 * MARK: 是否可以申请达人
 * 检查循序:
 *  一、是否有活体。
 *  二、是否有真实头像
 *      1.系统配置。
 *      2.是否拥有真实头像。
 *      3.头像审核中，是否有旧的可用头像。
 */
- (BOOL)canApplyTalentWithBlock:(void (^)(BOOL success, NSInteger infoIncompleteType, BOOL isCancel))block {
    if (![self didHaveRealFace]) {
        [self cantProceedAction:0
                          title:@"目前账户安全级别较低，将进行身份识别，否则无法发布出租信息"
                        message:nil
                           done:@"前往"
                    cancelTitle:@"取消"
                          block:block];
        return NO;
    }
    else {
        if ([self didHaveRealAvatar]) {
            if (block) {
                block(YES, 1, NO);
            }
            return YES;
        }
        else {
            if (![self.sysCofigModel canProceedWithoutRealAvatar:NavigationTypeApplyTalent]) {
                
                // 人工审核失败
                if (self.uModel.avatar_manual_status == 3) {
                    [self cantProceedAction:1
                                      title:@"您需要使用本人正脸五官清晰照，才能获取达人资格，请前往上传真实头像"
                                    message:nil
                                       done:@"前往"
                                cancelTitle:@"取消"
                                      block:block];
                    return NO;
                }
                else if (![self didHaveRealAvatar] && ![self isAvatarManualReviewing]) {
                    [self cantProceedAction:1
                                      title:@"您未上传本人正脸五官清晰照，无法发布出租信息，请前往上传真实头像"
                                    message:nil
                                       done:@"前往"
                                cancelTitle:@"取消"
                                      block:block];
                    return NO;
                }
            }
            
            if (block) {
                block(YES, 1, NO);
            }
            return YES;
        }
        
    }
}

- (NSString *)userFirstRent {
    NSString *name = [NSString stringWithFormat:@"userFirstRentuid=%@",self.uModel.uid];
    return [ZZUserDefaultsHelper objectForDestKey:name];
}

- (NSArray *)locationArray {
    NSString *locationArrPath = [NSString stringWithFormat:@"locationuid=%@",XJUserAboutManageer.uModel.uid];
    
    NSData *objectData = [ZZUserDefaultsHelper objectForDestKey:locationArrPath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
}

- (void)setLocationArray:(NSArray *)locationArray {
    NSString *locationArrPath = [NSString stringWithFormat:@"locationuid=%@",XJUserAboutManageer.uModel.uid];
    NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:locationArray];
    [ZZUserDefaultsHelper setObject:objectData forDestKey:locationArrPath];
}

/**
 * MARK: 请求么币和余额,并且更新
 */
+ (void)requestMeBiAndMoneynext:(requestCallback)next {
    [AskManager GET:@"api/user/mcoin" dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) {
            [ZZHUD showTastInfoErrorWithString:rError.message];
        } else {
            [ZZHUD dismiss];
            XJUserModel *user = XJUserAboutManageer.uModel;
            NSLog(@"之前有的么币: %d", user.mcoin);
            
            NSNumber *balance = [NSNumber numberWithDouble:[data[@"balance"] doubleValue]];
            NSNumber *mcoin = [NSNumber numberWithInteger:[data[@"mcoin_total"] integerValue]];
            user.balance = [balance floatValue];
            user.mcoin = mcoin;
            NSLog(@"之后的么币: %d", user.mcoin);
            XJUserAboutManageer.uModel = user;
//            [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
        }
        if (next) {
            next(rError,data,nil);
        }
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError,nil,nil);
        }
    }];

}

@end
