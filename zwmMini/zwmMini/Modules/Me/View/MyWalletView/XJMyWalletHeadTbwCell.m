//
//  XJMyWalletHeadTbwCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyWalletHeadTbwCell.h"

@interface XJMyWalletHeadTbwCell()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *accountLb;

@end

@implementation XJMyWalletHeadTbwCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.mas_equalTo(72);
        }];
        self.headIV.layer.cornerRadius = 36;
        self.headIV.layer.masksToBounds = YES;
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headIV).offset(10);
            make.left.equalTo(self.headIV.mas_right).offset(12);
        }];
        
        [self.accountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLb);
            make.top.equalTo(self.nameLb.mas_bottom).offset(9);
        }];
        
        UILabel *listLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"账单记录" font:defaultFont(15) textInCenter:NO];
        listLb.textAlignment = NSTextAlignmentRight;
        [listLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
        }];
        
    }
    return self;
    
}

-(void)setUpContent:(XJUserModel *)model{
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.nameLb.text = model.nickname;
    self.accountLb.text = [NSString stringWithFormat:@"账号:%@",model.ZWMId];
    
}


- (UIImageView *)headIV{
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
    }
    return _headIV;
    
}
- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _nameLb;
    
}
- (UILabel *)accountLb{
    if (!_accountLb) {
        _accountLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _accountLb;
    
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
