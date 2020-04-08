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

#pragma mark - <#mark Title#>
/**
 *  MARK: 不需要真实头像也可以进行的操作
 */
- (BOOL)canProceedWithoutRealAvatar:(NavigationType)type {
    NSArray *shouldHaveAvatarArray = self.disable_module.no_have_real_avatar;
    NSString *key = nil;
    if (type == NavigationTypeWeChat) {
        key = @"add_wechat";
    }
    else if (type == NavigationTypeOrder) {
        key = @"add_order";
    }
    else if (type == NavigationTypeApplyTalent) {
        key = @"release_rent";
    }
    if (!isNullString(key) && [shouldHaveAvatarArray indexOfObject:key] != NSNotFound) {
        return NO;
    }
    return YES;
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
