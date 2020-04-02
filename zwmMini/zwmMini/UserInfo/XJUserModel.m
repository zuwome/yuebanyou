//
//  XJUserModel.m
//  zwmMini
//
//  Created by Batata on 2018/11/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJUserModel.h"
#import "XJSkill.h"
#import "XJTopic.h"
@implementation XJUserModel



//// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{@"emergency_contacts" : [XJContactPeople class],@"interests_new":[XJInterstsModel class],@"photos":[XJPhoto class],@"photos_origin":[XJPhoto class],@"tags_new":[XJInterstsModel class],@"works_new":[XJInterstsModel class]};
}

/*
 *  头像是否在审核中
 */
- (BOOL)isAvatarManualReviewing {
    return self.avatar_manual_status == 1;
}

/**
 *  MARK: 旧的可用头像: 是否有旧的可用头像
 */
- (BOOL)didHaveOldAvatar {
    return self.old_avatar.length > 0;
}

/**
 *  MARK: 是否拥有真实头像
 */
- (BOOL)didHaveRealAvatar {
    XJPhoto *photo = self.photos_origin.firstObject;
    if (photo && photo.face_detect_status == 3) {
        return YES;
    }
    return NO;
}

- (void)getBalance:(requestCallback)next {
    [AskManager GET:@"api/user/balance" dict:nil succeed:^(id data, XJRequestError *rError) {
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

}

/*
 *  可以显示的头像
 *  如果用户正在审核,并且有可用的旧头像, 就显示旧的头像. 如果没有就显示avatar.(这边东西多逻辑奇怪)
 */
- (NSString *)displayAvatar {
    if ([self isAvatarManualReviewing] && [self didHaveOldAvatar]) {
        return self.old_avatar;
    }
    else {
        if ([self.avatar isEqualToString:@"http://img.movtrip.com/user/avatar.png"]) {
            if (self.photos.count > 0) {
                XJPhoto *photo = self.photos[0];
                return photo.url;
            }
            else {
                return @"";
            }
        }
        else {
            return self.avatar;
        }
    }
}

+ (void)loadUser:(NSString *)uid
           param:(NSDictionary *)param
         succeed:(void (^)(id data,XJRequestError *rError))succeed
         failure:(void (^)(NSError *error))failure {
    NSString *path = ({
        NSString *s = @"";
        if (uid) {
            s = [NSString stringWithFormat:@"api/user/%@", uid];
        } else {
            s = [NSString stringWithFormat:@"api/user"];
        }
        s;
    });
    
    [AskManager GET:path dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
//        if (!rError && data) {
//            XJUserAboutManageer.access_token = data[@"access_token"];
//            XJUserAboutManageer.qiniuUploadToken = data[@"upload_token"];
//            XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data[@"user"]];
//            XJUserAboutManageer.uModel = userModel;
//        }
        if (succeed) {
            succeed(data, rError);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)loadUser:(NSString *)uid param:(NSDictionary *)param {
    NSString *path = ({
        NSString *s = @"";
        if (uid) {
            s = [NSString stringWithFormat:@"api/user/%@", uid];
        } else {
            s = [NSString stringWithFormat:@"api/user"];
        }
        s;
    });
    
    [AskManager GET:path dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError && data) {
            XJUserAboutManageer.access_token = data[@"access_token"];
            XJUserAboutManageer.qiniuUploadToken = data[@"upload_token"];
            XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data[@"user"]];
            XJUserAboutManageer.uModel = userModel;
            XJUserAboutManageer.isLogin = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)followWithUid:(NSString *)uid next:(requestCallback)next {
//    [AskManager POST:@"api/user/%@/follow" dict:nil succeed:^(id data, XJRequestError *rError) {
//
//    } failure:^(NSError *error) {
//
//    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/follow",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//        if (data) {
//            [ZZUserHelper shareInstance].updateAttentList = YES;
//        }
//    }];
}

- (void)unfollowWithUid:(NSString *)uid next:(requestCallback)next {
//    [UIAlertView showWithTitle:@"提示" message:@"取消关注之后，将无法及时获取TA的动态消息，确定取消关注TA吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/unfollow",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//                next(error, data, task);
//            }];
//        }
//    }];
}

@end



@implementation XJCityModel


@end


@implementation XJBanModel


@end

@implementation XJContactPeople



@end

@implementation XJInterstsModel


@end

@implementation XJStatisDataModel



@end

@implementation XJMarkModel



@end


@implementation XJPhoto



@end

@implementation XJPrivacyConfigModel



@end

@implementation XJPushConfigModel



@end

@implementation XJQQModel



@end
@implementation XJRealNameModel



@end
@implementation XJRealnamePic



@end

@implementation XJRent

+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{
        @"topics" : [XJTopic class],
        @"address" : [XJCityModel class],
        @"city" : [XJCityModel class],
    };
}


@end

@implementation XJTopicsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{@"skills" : [XJSkill class]};
}



@end

@implementation XJSkillModel

+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{@"photo" : [XJPhoto class],@"tags":[XJSkillTagModel class]};
}



@end

@implementation XJSkillDetail



@end

@implementation XJSkillTagModel



@end

@implementation XJSignTastDetailModel



@end

@implementation XJWechat



@end

@implementation XJWeibo



@end
