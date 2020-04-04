//
//  ZZSkillEditViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/7/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "XJBaseVC.h"
#import "XJTopic.h"

typedef NS_ENUM(NSInteger, SkillEditType) {
    SkillEditTypeAddSystemTheme,    //新增系统主题
    SkillEditTypeAddCustomTheme,    //新增自定义主题
    SkillEditTypeEditTheme,         //编辑已有主题
};

/**
 *  填写主题介绍
 */
@interface ZZSkillEditViewController : XJBaseVC

@property (nonatomic, strong) XJTopic *oldTopicModel;    //外部传入的技能模型数据

@property (nonatomic, assign) SkillEditType skillEditType;

@end
