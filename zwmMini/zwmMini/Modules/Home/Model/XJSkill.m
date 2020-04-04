//
//  XJSkill.m
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJSkill.h"

@implementation XJSkill

//// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"tags" : [ZZSkillTag class],
        @"photo" : [XJPhoto class],
        @"detail" : [ZZSkillDetail class],
    };
}

- (instancetype)init {
    if (self = [super init]) {
        if (self.detail == nil) {
            self.detail = [[ZZSkillDetail alloc] initIfNotfound];
        }
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"skillID": @"_id"
                                                                  }];
}

- (void)add:(requestCallback)next {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if (self.name) {
        [d setObject:self.name forKey:@"name"];
    }
    [AskManager POST:@"api/skill" dict:d succeed:^(id data, XJRequestError *rError) {
        if (next) {
            next(rError, data, nil);
        }
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
}

+ (void)syncWithParams:(NSDictionary *)params next:(requestCallback)next {
    [AskManager GET:@"api/skills" dict:params.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (next) {
            next(rError, data, nil);
        }
    } failure:^(NSError *error) {
        XJRequestError *rError = [[XJRequestError alloc] init];
        rError.code = error.code;
        rError.message = error.localizedDescription;
        if (next) {
            next(rError, nil, nil);
        }
    }];
}

- (void)setPrice:(NSString *)price {
    _price = price;
}

- (void)setSkillID:(NSString *)skillID {
    _skillID = skillID;
    _id = _skillID;
}

@end


@implementation ZZSkillDetail

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (instancetype)initIfNotfound {  //服务端未返回时,文字状态置为-1，防止与0：审核不通过 产生冲突。
    if (self = [super init]) {
        self.status = -1;
    }
    return self;
}

@end

@implementation ZZSkillTag

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
