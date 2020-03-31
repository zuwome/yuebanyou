//
//  XJNearTableViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/24.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJNearTableViewCell.h"


@interface XJNearTableViewCell()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UIImageView *genderIV;
@property(nonatomic,strong) UIImageView *identificationIV;
@property(nonatomic,strong) UIImageView *distanceIV;
@property(nonatomic,strong) UILabel *distanceLb;





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
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        [self.distanceIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.distanceLb);
            make.right.equalTo(self.distanceLb.mas_left).offset(-4);
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
        
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
