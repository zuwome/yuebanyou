//
//  ZZSkillOptionViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "XJBaseVC.h"
#import "XJTopic.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SkillOptionType) {
    SkillOptionTypeAdd,
    SkillOptionTypeEdit,
};

@interface ZZSkillOptionViewController : XJBaseVC

@property (nonatomic, assign) SkillOptionType type;
@property (nonatomic, strong) XJTopic *topic;

- (instancetype)initWithSkillID:(NSString *)skillID;

@end

NS_ASSUME_NONNULL_END
