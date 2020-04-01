//
//  XJSystemCofigModel.m
//  zwmMini
//
//  Created by Batata on 2018/12/10.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSystemCofigModel.h"

@implementation XJSystemCofigModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"skill_catalog" : [SkillCatalogModel class],
        @"version" : [ZZUpdateModel class],
        @"yj" : [ZZSystemYjConfigModel class],
        @"disable_module" : [ZZDisableModuleModel class],
    };
}


@end

@implementation ZZSystemYjConfigModel



@end

@implementation SkillCatalogModel



@end

@implementation WechatLookModel


@end

@implementation XJPriceConfigModel

@end

@implementation ZZUpdateModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"version" : @"newVersion"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"version" : [ZZVersionModel class],
    };
}

@end

@implementation ZZVersionModel


@end


@implementation ZZDisableModuleModel


@end
