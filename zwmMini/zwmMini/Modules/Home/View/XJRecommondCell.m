//
//  XJRecommondCell.m
//  zwmMini
//
//  Created by qiming xiao on 2020/4/30.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJRecommondCell.h"
#import "XJTopic.h"
#import "XJSkill.h"
#import "XJHomeListModel.h"
@interface XJRecommondCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *userIconImageView;

@property (nonatomic, strong) UILabel *skillDesLabel;

@property (nonatomic, strong) UILabel *skillLabel;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UIImageView *genderImageView;

@end

@implementation XJRecommondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    self.contentView.backgroundColor = RGB(245, 245, 245);
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.bgView];
    [_bgView addSubview:self.userIconImageView];
    [_bgView addSubview:self.skillDesLabel];
    [_bgView addSubview:self.skillLabel];
    
    [_userIconImageView addSubview:self.userNameLabel];
    [_userIconImageView addSubview:self.genderImageView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
        make.height.equalTo(@125);
    }];
    
    [_userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(_bgView);
        make.width.equalTo(@125);
    }];

    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView).offset(10);
        make.bottom.equalTo(_userIconImageView).offset(-5);
        make.width.lessThanOrEqualTo(@74);
    }];

    [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userNameLabel.mas_right).offset(5);
        make.centerY.equalTo(_userNameLabel);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];

    [_skillDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(10);
        make.top.equalTo(_bgView).offset(10);
        make.right.equalTo(_bgView).offset(-10);
    }];

    [_skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userIconImageView.mas_right).offset(10);
        make.bottom.equalTo(_bgView).offset(-10);
        make.right.equalTo(_bgView).offset(-10);
    }];
}

#pragma mark - getters and setters
- (void)setModel:(XJHomeListModel *)model {
    _model = model;
    
//    if (indexpath.row %2 == 0) {
//        [self.headIV cornerRadiusViewWithRadius:0 andTopLeft:NO andTopRight:YES andBottomLeft:NO andBottomRight:YES];
//    }else{
//
//    [self.headIV cornerRadiusViewWithRadius:0 andTopLeft:YES andTopRight:NO andBottomLeft:YES andBottomRight:NO];
//
//    }
    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.userNameLabel.text = model.user.nickname;
    self.genderImageView.image = model.user.gender == 1? GetImage(@"boyiimghome"):GetImage(@"girlimghome");
    
    
    
    XJSkill *mostCheapSkill = nil;
    for (XJTopic *topic in model.user.rent.topics) {
        if (topic.skills.count == 0) {  //主题无技能，跳过
            continue;
        }
        for (XJSkill *skill in topic.skills) {
            if (!mostCheapSkill) {
                mostCheapSkill = skill;
            }
            else if ([skill.price doubleValue] < [mostCheapSkill.price doubleValue]) {
                mostCheapSkill = skill;
            }
        }
    }
    
    if (mostCheapSkill != nil) {
        _skillLabel.hidden = NO;
        _skillDesLabel.hidden = NO;
        _skillLabel.text = mostCheapSkill.name;
        
        if (NULLString(mostCheapSkill.detail.content)) {
            if (mostCheapSkill.tags.count != 0) {
                NSMutableString *tagsStr = [[NSMutableString alloc] init];
                [mostCheapSkill.tags enumerateObjectsUsingBlock:^(ZZSkillTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tagsStr appendString:[NSString stringWithFormat:@"#%@ ", obj.tagname]];
                }];
                
                _skillDesLabel.text = tagsStr.copy;
            }
        }
        else {
            _skillDesLabel.text = mostCheapSkill.detail.content;
        }
        
//        if (NULLString(mostCheapSkill.detail.content)) {
//            _skillDesLabel.hidden = YES;
//            [_skillLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.headIV.mas_bottom).offset(10);
//            }];
//        }
//        else {
//            _skillDesLabel.hidden = NO;
//            [self.skillDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView).offset(10);
//                make.right.equalTo(self.contentView).offset(-10);
//                make.top.equalTo(self.headIV.mas_bottom).offset(10);
//            }];
//
//            [self.skillLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView).offset(10);
//                make.right.equalTo(self.contentView).offset(-10);
//                make.top.equalTo(self.skillDesLabel.mas_bottom).offset(10);
//            }];
//        }
    }
    else {
        _skillLabel.text = @"";
        _skillDesLabel.text = @"";
        
//        _skillDesLabel.hidden = YES;
//        _skillLabel.hidden = YES;
    }
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 3;
    }
    return _bgView;
}

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] init];
    }
    return _userIconImageView;
}

- (UIImageView *)genderImageView {
    if (!_genderImageView) {
        _genderImageView = [[UIImageView alloc] init];
    }
    return _genderImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = ADaptedFontMediumSize(11);
        _userNameLabel.textColor = RGB(247, 247, 247);
    }
    return _userNameLabel;
}

- (UILabel *)skillDesLabel {
    if (!_skillDesLabel) {
        _skillDesLabel = [[UILabel alloc] init];
        _skillDesLabel.font = ADaptedFontMediumSize(15);
        _skillDesLabel.textColor = RGB(63, 58, 58);
        _skillDesLabel.numberOfLines = 3;
    }
    return _skillDesLabel;
}

- (UILabel *)skillLabel {
    if (!_skillLabel) {
        _skillLabel = [[UILabel alloc] init];
        _skillLabel.font = ADaptedFontMediumSize(13);
        _skillLabel.textColor = RGB(102, 102, 102);
    }
    return _skillLabel;
}


@end
