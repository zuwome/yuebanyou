//
//  ZZThirdPayHelper.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/15.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZThirdPayHelper.h"

@implementation ZZThirdPayHelper

+ (void)pingxxRetrieve:(NSString *)payId next:(requestCallback)next {
    [AskManager GET:@"pingxx/retrieve" dict:@{@"id":payId}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        next(rError, nil, nil);
    }];
//    [ZZRequest method:@"GET" path:@"/pingxx/retrieve" params:@{@"id":payId} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

@end
