//
//  XJRentModel.h
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJUserModel.h"
@class XJTopic;
@interface XJRentModel : NSObject

@property (strong, nonatomic) NSDate *updated_at;
@property (assign, nonatomic) NSInteger status; //0、未出租 1、待审核 2、已上架 3、已下架
@property (assign, nonatomic) BOOL show;
@property (strong, nonatomic) XJCityModel *city;
@property (strong, nonatomic) NSArray *time;
@property (strong, nonatomic) NSString *people;

// 创建时间
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSMutableArray<XJTopic *> *topics;

@property (strong, nonatomic) NSNumber<Ignore> *minPrice;

@property (assign, nonatomic) NSUInteger paid_status; //0未付费（老用户和未付费的新用户都返回0）  1:已过期  2:未过期
@property (copy, nonatomic) NSString *expired_at_text;//会员时间信息 "到期时间2017-12-30"

@property (nonatomic,   copy) NSString *showTxt;

- (void)enable:(BOOL)show next:(requestCallback)next;

@end

