//
//  ZZRuleHelper.m
//  zuwome
//
//  Created by wlsy on 16/1/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRuleHelper.h"

@implementation ZZRuleHelper

+ (void)pullRefuseList:(requestCallback)next {
    [AskManager GET:@"api/rule/refuse" dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) [ZZHUD showTastInfoErrorWithString:rError.message];
        else next(rError, data, nil);
    } failure:^(NSError *error) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.localizedDescription];
    }];
//    [ZZRequest method:@"GET" path:@"/api/rule/refuse" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}
+ (void)pullCancelList:(requestCallback)next {
    [AskManager GET:@"api/rule/cancel" dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) [ZZHUD showTastInfoErrorWithString:rError.message];
        else next(rError, data, nil);
    } failure:^(NSError *error) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.localizedDescription];
    }];
//    [ZZRequest method:@"GET" path:@"/api/rule/cancel" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}
+ (void)pullRefundList:(requestCallback)next {
    [AskManager GET:@"api/rule/refund2" dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) [ZZHUD showTastInfoErrorWithString:rError.message];
        else next(rError, data, nil);
    } failure:^(NSError *error) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.localizedDescription];
    }];
//    [ZZRequest method:@"GET" path:@"/api/rule/refund2" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}
+ (void)pullAppealList:(requestCallback)next {
    [AskManager GET:@"api/rule/appeal" dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) [ZZHUD showTastInfoErrorWithString:rError.message];
        else next(rError, data, nil);
    } failure:^(NSError *error) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.localizedDescription];
    }];
//    [ZZRequest method:@"GET" path:@"/api/rule/appeal" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

+ (void)pullDepositList:(requestCallback)next
{
    [AskManager GET:@"api/rule/refund_deposit" dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) [ZZHUD showTastInfoErrorWithString:rError.message];
        else next(rError, data, nil);
    } failure:^(NSError *error) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.localizedDescription];
    }];
//    [ZZRequest method:@"GET" path:@"/api/rule/refund_deposit" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

+ (void)pullRefund:(NSDictionary *)param next:(requestCallback)next
{
    [AskManager GET:@"api/rule" dict:nil succeed:^(id data, XJRequestError *rError) {
        if (rError) [ZZHUD showTastInfoErrorWithString:rError.message];
        else next(rError, data, nil);
    } failure:^(NSError *error) {
        if (error) [ZZHUD showTastInfoErrorWithString:error.localizedDescription];
    }];
//    [ZZRequest method:@"GET" path:@"/api/rule" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

@end
