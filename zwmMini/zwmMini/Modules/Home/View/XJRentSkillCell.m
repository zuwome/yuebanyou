//
//  XJRentSkillCell.m
//  zwmMini
//
//  Created by qiming xiao on 2020/3/31.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJRentSkillCell.h"

#import "XJRentSkillItemView.h"

#import "XJTopic.h"
@interface XJRentSkillCell()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation XJRentSkillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - response method
- (void)selectSkill:(UITapGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:selectSkill:)]) {
        XJRentSkillItemView *view = (XJRentSkillItemView *)recognizer.view;
        [self.delegate cell:self selectSkill:view.topic];
    }
}

- (void)configureData {
    __block XJRentSkillItemView *topView = nil;
    [_skillsArr enumerateObjectsUsingBlock:^(XJTopic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XJRentSkillItemView *skillView = [self createSkillView:obj isFirst:idx == 0];
        [_bgView addSubview:skillView];
        [skillView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_bgView);
            make.top.equalTo(topView ? topView.mas_bottom : _bgView);
            
            if (idx == _skillsArr.count - 1) {
                make.bottom.equalTo(_bgView);
            }
            topView = skillView;
        }];
    }];
}

#pragma mark - Layout
- (void)layout {
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self);
    }];
}

- (XJRentSkillItemView *)createSkillView:(XJTopic *)topic isFirst:(BOOL)isFirst {
    XJRentSkillItemView *view = [[XJRentSkillItemView alloc] init];
    [view setData:topic isFirst:isFirst];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSkill:)];
    [view addGestureRecognizer:tap];
    return view;
}

#pragma mark - getters and setters
-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultWhite];
        _bgView.layer.shadowOffset = CGSizeMake(1,1);
        _bgView.layer.shadowOpacity = 0.3;
        _bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
    
}

- (void)setSkillsArr:(NSArray<XJTopic *> *)skillsArr {
    _skillsArr = skillsArr;
    [self configureData];
}

@end
