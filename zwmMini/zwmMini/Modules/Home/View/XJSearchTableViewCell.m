//
//  XJSearchTableViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/22.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSearchTableViewCell.h"

@interface XJSearchTableViewCell()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UIImageView *genderIV;

@end

@implementation XJSearchTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.mas_equalTo(58);
        }];
        self.headIV.layer.cornerRadius = 29;
        self.headIV.layer.masksToBounds = YES;
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headIV);
            make.left.equalTo(self.headIV.mas_right).offset(12);
        }];
        
        [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headIV);
            make.left.equalTo(self.nameLb.mas_right).offset(10);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
    
}


- (void)setModel:(XJUserModel *)model{
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.nameLb.text = model.nickname;
    self.genderIV.image = model.gender == 1? GetImage(@"boyimg"):GetImage(@"girlimg");
    
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
- (UILabel *)nameLb{
    
    if (!_nameLb) {
        
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _nameLb;
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
