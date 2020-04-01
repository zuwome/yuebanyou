//
//  XJRentSkillCell.h
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJTopic;
@class XJRentSkillCell;
@protocol XJRentSkillCellDelegate<NSObject>

- (void)cell:(XJRentSkillCell *)cell selectSkill:(XJTopic *)topic;

@end

@interface XJRentSkillCell : UITableViewCell

@property (nonatomic, weak) id<XJRentSkillCellDelegate> delegate;

@property (nonatomic, copy) NSArray<XJTopic *> *skillsArr;

@end

