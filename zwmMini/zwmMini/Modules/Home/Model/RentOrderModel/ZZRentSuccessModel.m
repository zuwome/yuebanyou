//
//  ZZRentSuccessModel.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/7.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRentSuccessModel.h"
/**
 出租成功的model
 */
@implementation ZZRentSuccessModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}


/**
 先读取上次的数据,当服务器返回的时候再更新

 @param next <#next description#>
 */
+ (void )getRentSuccessCallBack:(void(^)(ZZRentSuccessModel *rentSuccessModel))next {
       id getRentSuccessValue =[ZZUserDefaultsHelper objectForDestKey:@"getRentSuccessKey"];
    
    if (getRentSuccessValue) {
        ZZRentSuccessModel *model = [[ZZRentSuccessModel alloc]initWithDictionary:getRentSuccessValue error:nil] ;

        if (next) {
            next(model);
        }
    }
    [AskManager GET:@"api/rent/apply_success" dict:nil succeed:^(id data, XJRequestError *rError) {
        dispatch_async(dispatch_get_main_queue(), ^{
               [ZZHUD dismiss];
               if (rError) {
                   [ZZHUD showTaskInfoWithStatus:rError.message];
               }
           });
           if (data) {
        
               ZZRentSuccessModel *model = [[ZZRentSuccessModel alloc]initWithDictionary:data error:nil] ;
                      [ZZUserDefaultsHelper setObject:data forDestKey:@"getRentSuccessKey"];
               if (next) {
                   next(model);
               }
           }
    } failure:^(NSError *error) {
        [ZZHUD dismiss];
        if (error) {
            [ZZHUD showTaskInfoWithStatus:error.localizedDescription];
        }
    }];
}
@end
