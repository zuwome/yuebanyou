//
//  ZZTransfer.m
//  zuwome
//
//  Created by wlsy on 16/2/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZTransfer.h"

@implementation ZZTransfer

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (void)add:(requestCallback)next {
    NSString *jsonString = [self yy_modelToJSONString];
    if (jsonString == nil) {
        NSLog(@"json解析失败");
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
    
    }
    
    NSString *path = [NSString stringWithFormat:@"api/user/transfer"];
    [AskManager POST:path dict:dic1.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:path params:[self toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

- (void)rechargeWithParam:(NSDictionary *)param next:(requestCallback)next
{
    [AskManager POST:@"api/user/recharge" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"POST" path:@"/api/user/recharge" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

@end
