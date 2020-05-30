//
//  XJNearTableViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/24.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJNearTableViewCell.h"
#import "XJTopic.h"
#import "XJSkill.h"

@interface XJNearTableViewCell()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UIImageView *genderIV;
@property(nonatomic,strong) UIImageView *identificationIV;
@property(nonatomic,strong) UIImageView *distanceIV;
@property(nonatomic,strong) UILabel *distanceLb;
@property (nonatomic, strong) UILabel *skillLabel;
@property (nonatomic, strong) UILabel *skillDesLabel;

@end

@implementation XJNearTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        

        self.headIV.frame = CGRectMake(11, 4, 124, 124);
        [self.headIV cornerRadiusViewWithRadius:6 andTopLeft:YES andTopRight:NO andBottomLeft:YES andBottomRight:NO];

        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.headIV.mas_right).offset(10);
        }];
        
        [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.left.equalTo(self.nameLb.mas_right).offset(6);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
        [self.identificationIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(14);
            make.centerY.equalTo(self.genderIV);
            make.left.equalTo(self.genderIV.mas_right).offset(6);

        }];
        [self.distanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-17);
            make.centerY.equalTo(self.nameLb);
        }];
        [self.distanceIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.right.equalTo(self.distanceLb.mas_left).offset(-4);
        }];
        
        [self.skillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLb.mas_bottom).offset(5);
            make.left.equalTo(self.headIV.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        [self.skillDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headIV).offset(-8);
            make.left.equalTo(self.headIV.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
    }
    return self;
}
- (void)setModel:(XJHomeListModel *)model{
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.nameLb.text = model.user.nickname;
    self.genderIV.image = model.user.gender == 1? GetImage(@"boyiimghome"):GetImage(@"girlimghome");
    self.identificationIV.hidden = model.user.realname.status == 2 ? NO: YES;
    self.distanceLb.text = model.distance;
    
    
//    XJSkill *mostCheapSkill = nil;
//    for (XJTopic *topic in model.user.rent.topics) {
//        if (topic.skills.count == 0) {  //主题无技能，跳过
//            continue;
//        }
//        for (XJSkill *skill in topic.skills) {
////            if (skill.topicStatus != 2 && skill.topicStatus != 4) { //没通过审核
////                continue;
////            }
//            if (!mostCheapSkill) {
//                mostCheapSkill = skill;
//            }
//            else if ([skill.price doubleValue] < [mostCheapSkill.price doubleValue]) {
//                mostCheapSkill = skill;
//            }
////            if (mostCheapSkill == nil || [skill.price floatValue] < [mostCheapSkill.price floatValue]) {
////                mostCheapSkill = skill;
////            }
//        }
//    }
//    
//    // 技能名称、价格、介绍
//    if (mostCheapSkill == nil) {
//        _skillLabel.text = @" ";
//        _skillDesLabel.text = @" ";
//    }
//    else {
//        _skillLabel.text = mostCheapSkill.name;
//        _skillDesLabel.text = mostCheapSkill.detail.content;
//    }
}



#pragma mark lazy
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
- (UILabel *)nameLb{
    
    if (!_nameLb) {
        
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:ADaptedFontSCBoldSize(17) textInCenter:NO];
    }
    return _nameLb;
}
- (UIImageView *)identificationIV{
    
    if (!_identificationIV) {
        
        _identificationIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@"iconIdentify"];
        
    }
    return _identificationIV;
    
    
}
- (UILabel *)distanceLb{
    
    if (!_distanceLb) {
        
        _distanceLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(122, 122, 122) text:@"" font:defaultFont(12) textInCenter:NO];
    }
    return _distanceLb;
}
- (UIImageView *)distanceIV{
    
    if (!_distanceIV) {
        
        _distanceIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@"distance1"];
        
    }
    return _distanceIV;
    
    
}

- (UILabel *)skillLabel{
    if (!_skillLabel) {
        _skillLabel = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(63, 58, 58) text:@"" font:[UIFont fontWithName:@"PingFangSC-Medium" size:12] textInCenter:NO];
    }
    return _skillLabel;
}

- (UILabel *)skillDesLabel{
    if (!_skillDesLabel) {
        _skillDesLabel = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(102, 102, 102) text:@"" font:[UIFont fontWithName:@"PingFangSC-Medium" size:13] textInCenter:NO];
        _skillDesLabel.numberOfLines = 3;
    }
    return _skillDesLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
