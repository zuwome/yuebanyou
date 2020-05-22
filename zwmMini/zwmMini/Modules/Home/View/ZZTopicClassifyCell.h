//
//  ZZTopicClassifyCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHomeModel.h"
#import "XJTopic.h"
#import "XJSkill.h"
#define TopicClassifyCellId @"TopicClassifyCellId"

@interface ZZTopicClassifyCell : UITableViewCell

@property (nonatomic, strong) ZZUserUnderSkillModel *model;

@property (nonatomic, copy) void(^gotoUserInfo)(XJUserModel *user);
@property (nonatomic, copy) void(^gotoSkillDetail)(XJUserModel *user, XJTopic *topic);

@end
