//
//  ZZNewHomeTopicCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZHomeCatalogModel;
/**
 *  新版首页 -- 精选技能主题
 */
@interface ZZNewHomeTopicView : UIView

@property (nonatomic, strong) NSArray *topics;      //主题数据

@property (nonatomic, copy) void(^topicChooseCallback)(ZZHomeCatalogModel *topic);   //技能主题选择

@end
