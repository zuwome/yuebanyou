//
//  XJRentSkillItemView.h
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKTagView;
@class XJTopic;

@interface XJRentSkillItemView : UIView

@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *skillIcon;
@property (nonatomic, strong) UILabel *skillContent;
@property (nonatomic, strong) SKTagView *tagView;
@property (nonatomic, strong) XJTopic *topic;

- (void)setData:(XJTopic *)topic isFirst:(BOOL)isFirst;

@end
