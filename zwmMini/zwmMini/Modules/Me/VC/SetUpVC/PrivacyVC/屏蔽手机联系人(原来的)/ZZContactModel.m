//
//  ZZContactModel.m
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZContactModel.h"

@implementation ZZContactModel

- (void)blcokContact:(NSDictionary *)param next:(requestCallback)next {
    [AskManager POST:@"api/user/contacts/block" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        next(rError,data,nil);
    } failure:^(NSError *error) {
        
    }];
}

- (void)unblockContact:(NSDictionary *)param next:(requestCallback)next {
    [AskManager POST:@"api/user/contacts/unblock" dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        next(rError,data,nil);
    } failure:^(NSError *error) {
        
    }];
}

- (void)getContactBlockList:(requestCallback)next {
    [AskManager GET:@"api/user/block/contacts" dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
          next(rError,data,nil);
    } failure:^(NSError *error) {
        
    }];
}

@end
