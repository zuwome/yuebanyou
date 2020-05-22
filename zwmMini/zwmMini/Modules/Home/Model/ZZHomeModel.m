//
//  ZZHomeModel.m
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeModel.h"
#import "XJSkill.h"
#import "XJTopic.h"

@implementation ZZHomeAdModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"aid"
                                                       }];
}

@end


@implementation ZZHomeRecommendModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZHomeCatalogModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZHomeBannerModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        if (self.img == nil) {
            self.img = @"";
        }
        if (self.background == nil) {
            self.background = @"";
        }
    }
    return self;
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZHomeChatModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZHomeIntroduceItemModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZHomeIntroduceModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation PdModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

@end

@implementation ZZUserUnderSkillModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

//// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{@"skill" : [XJSkill class],
             @"user":[XJUserModel class],};
}

@end

@implementation ZZHomeModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"typeID"
                                                       }];
}

+ (void)getUserUnderSkill:(NSString *)catalogId withSortValue:(NSString *)sortValue pageIndex:(NSInteger)pageIndex next:(requestCallback)next {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"catalogId":catalogId, @"pageIndex": @(pageIndex)}];
    if (!isNullString(sortValue)) {
        [params setObject:sortValue forKey:@"sortValue"];   //分页
    }
    
    [AskManager GET:@"api/skill/getunderskill3_7_2" dict:params.mutableCopy succeed:^(id data, XJRequestError *rError) {
        next(rError, data, nil);
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
//    [ZZRequest method:@"GET" path:@"/api/skill/getunderskill3_7_2" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
}

//+ (void)getIndexPageData:(requestCallback)next {
//    NSDictionary *params;
//    if ([ZZUserHelper shareInstance].isLogin) {
//        if (!isNullString([ZZUserHelper shareInstance].loginer.uid)) {
//            params = @{@"uid":[ZZUserHelper shareInstance].loginer.uid};
//        }
//    }
//    [ZZRequest method:@"GET" path:@"/index/page_data" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        next(error, data, task);
//    }];
//}

//计算最低价格的技能（需要判断审核状态时，取消方法里的注释）
//+ (ZZSkill *)getMostCheapSkill:(NSArray<ZZTopic *> *)topics {
//    ZZSkill *mostCheapSkill = nil;
//    for (ZZTopic *topic in topics) {
//        if (topic.skills.count == 0) {  //主题无技能，跳过
//            continue;
//        }
//        for (ZZSkill *skill in topic.skills) {
////            if (skill.topicStatus != 2 && skill.topicStatus != 4) { //没通过审核
////                continue;
////            }
//            if (!mostCheapSkill) {
//                mostCheapSkill = skill;
//            }
//            else if ([skill.price doubleValue] < [mostCheapSkill.price doubleValue]) {
//                mostCheapSkill = skill;
//            }
////            if (mostCheapSkill == nil || [skill.price floatValue] < [mostCheapSkill.price floatValue]) {
////                mostCheapSkill = skill;
////            }
//        }
//    }
//    return mostCheapSkill;
//}
//计算最低价格（需要判断审核状态时，取消方法里的注释）
//+ (NSString *)getMostCheapSkillPrice:(NSArray<XJTopic *> *)topics {
//    NSString *price = @"";
//    for (ZZTopic *topic in topics) {
//        if (topic.skills.count == 0) {  //主题无技能，跳过
//            continue;
//        }
//        if (isNullString(price) || [price floatValue] > [topic.price floatValue]) {
//            price = topic.price;
//        }
//        for (ZZSkill *skill in topic.skills) {
////            if (skill.topicStatus != 2 && skill.topicStatus != 4) { //没通过审核
////                continue;
////            }
//            if (skill.price && [skill.price floatValue] < [price floatValue]) {
//                price = skill.price;
//            }
//        }
//    }
//    return price;
//}

@end
