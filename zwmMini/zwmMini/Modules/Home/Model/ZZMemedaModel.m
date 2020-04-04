//
//  ZZMemedaModel.m
//  zuwome
//
//  Created by angBiu on 16/8/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaModel.h"

@implementation ZZMMDTipsModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZMMDVideoModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZMMDAnswersModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"answerId"
                                                       }];
}

@end

@implementation ZZMMDModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"mid"
                                                       }];
}

@end

@implementation ZZMemedaModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)getUserMemedaList:(NSDictionary *)param next:(requestCallback)next
{
    [AskManager GET:@"api/user/mmds" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"GET" path:@"/api/user/mmds" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)getDynamicList:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [AskManager GET:[NSString stringWithFormat:@"api/user/%@/mmds",uid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/mmds",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)shareCallBack:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/share",mid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/share",mid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

+ (void)getMemedaDetaiWithMid:(NSString *)mid next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"/mmd/%@/detail",mid];
    if (XJUserAboutManageer.isLogin) {
        path = [NSString stringWithFormat:@"/api/mmd/%@/detail",mid];
    }
    [AskManager GET:path dict:nil succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
    
//    [ZZRequest method:@"GET" path:path params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)payMemedaWithParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/pay",mid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
    
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/pay",mid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)dashangMememdaWithParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/tip",mid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
    
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/tip",mid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)addMemedaWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/to/%@/add",uid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/to/%@/add",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)answerMemedaParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/answer",mid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/answer",mid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)updateAnswerMemedaParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/re_answer",mid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/re_answer",mid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)commentMememdaParam:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/reply",mid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/reply",mid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

+ (void)getMemedaCommentList:(NSDictionary *)param mid:(NSString *)mid next:(requestCallback)next
{
    NSString *path = [NSString stringWithFormat:@"mmd/%@/replies",mid];
    if (XJUserAboutManageer.isLogin) {
        path = [NSString stringWithFormat:@"api/mmd/%@/replies",mid];
    }
    [AskManager GET:path dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"GET" path:path params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)deleteMemedaComment:(NSString *)mid replyId:(NSString *)replyId next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/reply/%@/del",mid,replyId] dict:nil succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/reply/%@/del",mid,replyId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

+ (void)zanMemeda:(ZZMMDModel *)model next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/like",model.mid] dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) {
            [ZZHUD showErrorWithStatus:rError.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
            model.like_count++;
            next(rError, data, nil);
        }
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        [ZZHUD showErrorWithStatus:error.localizedDescription];
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/like",model.mid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        if (error) {
//            [ZZHUD showErrorWithStatus:error.message];
//        } else {
//            [ZZHUD showSuccessWithStatus:@"点赞成功"];
//            model.like_count++;
//            next(error, data, task);
//        }
//    }];
}

+ (void)unzanMemeda:(ZZMMDModel *)model next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/unlike",model.mid] dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) {
            [ZZHUD showErrorWithStatus:rError.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"取消赞"];
            if (model.like_count) {
                model.like_count--;
            }
            next(rError, data, nil);
        }
    } failure:^(NSError *error) {
        [ZZHUD showErrorWithStatus:error.localizedDescription];
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/unlike",model.mid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        if (error) {
//            [ZZHUD showErrorWithStatus:error.message];
//        } else {
//            [ZZHUD showSuccessWithStatus:@"取消赞"];
//            if (model.like_count) {
//                model.like_count--;
//            }
//            next(error, data, task);
//        }
//    }];
}

- (void)getHotMemedaUid:(NSString *)uid next:(requestCallback)next
{
    [AskManager GET:[NSString stringWithFormat:@"api/user/%@/hot_mmds",uid] dict:nil succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
    
//    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/%@/hot_mmds",uid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

#pragma mark - 发现

- (void)getFindNewMemeda:(NSDictionary *)param next:(requestCallback)next
{
    [AskManager GET:@"mmds" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
    
//    [ZZRequest method:@"GET" path:@"/mmds" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)getFindNewMemedaNeedLogin:(NSDictionary *)param next:(requestCallback)next
{
    [AskManager GET:@"api/mmds" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"GET" path:@"/api/mmds" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)getFindHotMemeda:(NSDictionary *)param next:(requestCallback)next
{
    [AskManager GET:@"mmds" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
    
//    [ZZRequest method:@"GET" path:@"/mmds" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)getFindHotMemedaNeedLogin:(NSDictionary *)param next:(requestCallback)next
{
    [AskManager GET:@"api/mmds" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"GET" path:@"/api/mmds" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

+ (void)deleteMemeda:(NSString *)mid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/mmd/%@/del",mid] dict:nil succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/mmd/%@/del",mid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

@end
