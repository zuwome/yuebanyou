//
//  XJRecommondCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRecommondCollectionViewCell.h"
#import "XJTopic.h"
#import "XJSkill.h"
@interface XJRecommondCollectionViewCell ()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UIImageView *genderIV;
@property(nonatomic,strong) UIImageView *kuangIV;

@property (nonatomic, strong) UILabel *skillLabel;

@property (nonatomic, strong) UILabel *skillDesLabel;


@end


@implementation XJRecommondCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.contentView.layer.cornerRadius = 6;
        
        self.headIV.frame = CGRectMake(0, 0, (kScreenWidth/2.f) -3.5, (kScreenWidth/2.f) -3.5);
       
        [self.kuangIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.headIV);
            make.height.mas_equalTo(39);
        }];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headIV).offset(-5);
            make.left.equalTo(self.headIV).offset(10);
        }];
        
        [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.left.equalTo(self.nameLb.mas_right).offset(2);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
        
        [self.skillDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.headIV.mas_bottom).offset(10);
        }];
        
        [self.skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.skillDesLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}


- (void)setUpContent:(XJHomeListModel *)model withIndexpath:(NSIndexPath *)indexpath{
    
    if (indexpath.row %2 == 0) {
        [self.headIV cornerRadiusViewWithRadius:0 andTopLeft:NO andTopRight:YES andBottomLeft:NO andBottomRight:YES];
    }else{
        
    [self.headIV cornerRadiusViewWithRadius:0 andTopLeft:YES andTopRight:NO andBottomLeft:YES andBottomRight:NO];

    }
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.nameLb.text = model.user.nickname;
    self.genderIV.image = model.user.gender == 1? GetImage(@"boyiimghome"):GetImage(@"girlimghome");
    
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
        _skillDesLabel.text = mostCheapSkill.detail.content;
        
        
        if (NULLString(mostCheapSkill.detail.content)) {
//            _skillDesLabel.hidden = YES;
//            [_skillLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.headIV.mas_bottom).offset(10);
//            }];
            if (mostCheapSkill.tags.count != 0) {
                NSMutableString *tagsStr = [[NSMutableString alloc] init];
                [mostCheapSkill.tags enumerateObjectsUsingBlock:^(ZZSkillTag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tagsStr appendString:[NSString stringWithFormat:@"#%@ ", obj.tagname]];
                }];
                
                _skillDesLabel.text = tagsStr.copy;
            }
        }
        else {
            _skillDesLabel.hidden = NO;
            [self.skillDesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(10);
                make.right.equalTo(self.contentView).offset(-10);
                make.top.equalTo(self.headIV.mas_bottom).offset(10);
            }];
            
            [self.skillLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(10);
                make.right.equalTo(self.contentView).offset(-10);
                make.top.equalTo(self.skillDesLabel.mas_bottom).offset(10);
            }];
        }
    }
    else {
        _skillDesLabel.hidden = YES;
        _skillLabel.hidden = YES;
    }
    
}

- (UIImageView *)headIV{
    
    if (!_headIV) {
        
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
        
    }
    return _headIV;
    
    
}
- (UIImageView *)genderIV{
    
    if (!_genderIV) {
        
        _genderIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
        
    }
    return _genderIV;
    
    
}
- (UIImageView *)kuangIV{
    
    if (!_kuangIV) {
        
        _kuangIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@"mask"];
        
    }
    return _kuangIV;
    
    
}
- (UILabel *)nameLb{
    
    if (!_nameLb) {
        
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultWhite text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _nameLb;
}

- (UILabel *)skillLabel{
    if (!_skillLabel) {
        _skillLabel = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(102, 102, 102) text:@"" font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] textInCenter:NO];
    }
    return _skillLabel;
}

- (UILabel *)skillDesLabel{
    if (!_skillDesLabel) {
        _skillDesLabel = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(68, 53, 53) text:@"" font:[UIFont boldSystemFontOfSize:16] textInCenter:NO];
        _skillDesLabel.numberOfLines = 3;
    }
    return _skillDesLabel;
}
@end
