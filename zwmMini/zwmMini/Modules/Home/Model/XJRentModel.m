//
//  XJRentModel.m
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJRentModel.h"
#import "XJTopic.h"

@implementation XJRentModel

//// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{
        @"city" : [XJCityModel class],
        @"topics" : [XJTopic class]
    };
}

- (NSNumber *)minPrice {
    __block float xmin = MAXFLOAT;
    [self.topics enumerateObjectsUsingBlock:^(XJTopic *topic, NSUInteger idx, BOOL * _Nonnull stop) {
        float x = [topic.price floatValue];
        if (x < xmin) xmin = x;
    }];
    if (xmin == MAXFLOAT) {
        xmin = 0;
    }
    return @(xmin);
}

- (void)enable:(BOOL)show next:(requestCallback)next {
    if (show) {
        [AskManager POST:@"/api/rent/show" dict:nil succeed:^(id data, XJRequestError *rError) {
            if (next) {
                next(rError, data, nil);
            }
        } failure:^(NSError *error) {
            // XJRequestError *er
        }];
    }
    else {
        [AskManager Delete:@"/api/rent/show" dict:nil succeed:^(id data, XJRequestError *rError) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

@end
