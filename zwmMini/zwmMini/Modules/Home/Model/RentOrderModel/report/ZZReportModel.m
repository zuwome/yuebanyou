//
//  ReportModel.m
//  zuwome
//
//  Created by angBiu on 16/5/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZReportModel.h"
#import <QiniuSDK.h>

@implementation ZZReportModel

+ (void)reportWithParam:(NSDictionary *)param uid:(NSString *)uid next:(requestCallback)next
{
    [AskManager POST:[NSString stringWithFormat:@"api/user/%@/report",uid] dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (rError) [ZZHUD showTastInfoErrorWithString:rError.message];
        else next(rError, data, nil);
    } failure:^(NSError *error) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.localizedDescription];
    }];
//    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/report",uid] params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error,data,task);
//    }];
}

@end
