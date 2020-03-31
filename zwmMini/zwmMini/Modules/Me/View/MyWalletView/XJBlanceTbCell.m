//
//  XJBlanceTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBlanceTbCell.h"

@interface XJBlanceTbCell()

@property(nonatomic,strong) UIImageView *typeIV;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *moneyLb;



@end

@implementation XJBlanceTbCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.typeIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(60);
        }];
        self.typeIV.layer.cornerRadius = 30;
        self.typeIV.layer.masksToBounds = YES;
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeIV.mas_right).offset(12);
            make.bottom.equalTo(self.typeIV.mas_centerY).offset(-2);
        }];
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeIV.mas_right).offset(12);
            make.top.equalTo(self.typeIV.mas_centerY).offset(2);
        }];
        
        [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
        }];
        
        
        
    }
    return self;
    
}



- (void)setUpContent:(XJBlanceRecordModel *)bmodel{
    self.contentLb.text = bmodel.content;
    self.timeLb.text = bmodel.created_at;
    self.moneyLb.text = [NSString stringWithFormat:@"%.2f元",bmodel.amount];
    NSArray *types = @[@"order",@"pd_pay_deposit_refund",@"pd_pay_deposit",@"transfer",@"recharge",@"private_mmd_refund",@"private_mmd_pay",@"private_mmd_answer",@"mmd_tip_jl",@"mmd_refund",@"mmd_answer",@"mmd_tip_to",@"mmd_tip",@"mmd_pay",@"sk_tip",@"sk_tip_to",@"rp_pay",@"rp_take",@"sys_rp_refund",@"rp_refund",@"pay_for_wechat",@"get_from_wechat",@"qchat",@"chatcharge"];
    NSInteger typeIdx = [types indexOfObject:bmodel.type];

    switch (typeIdx) {
        case 0:case 1:case 2:case 3:
        {
                self.typeIV.image = GetImage(@"icDate");
        }
            break;
            case 4:
        {
            if ([bmodel.channel isEqualToString:@"wx"]) {
                self.typeIV.image = GetImage(@"wechatC");

            }else{
                self.typeIV.image = GetImage(@"alipayC");

                
            }

        }
        case 5:case 6:case 7:case 8:case 9:case 10:case 11:case 12:case 13:case 14:case 15:case 16:case 17:case 18:case 19:
        {
            self.typeIV.image = GetImage(@"icRedPackets");
    
        }
        case 20:case 21:
        {
            self.typeIV.image = GetImage(@"wechatC");

        }
        case 22:
        {
            self.typeIV.image = GetImage(@"Chat_icShipinChat");

            
        }
        case 23:
        {
            self.typeIV.image = GetImage(@"icSixinZhangdanMebijilu");

        }
        case 24:
        {
            self.typeIV.image = GetImage(@"icDefault");

            
        }
        default:
            self.typeIV.image = GetImage(@"icDefault");

            break;
    }
    
}

- (UIImageView *)typeIV{
    
    if (!_typeIV) {
        
        _typeIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
    }
    return _typeIV;
}

- (UILabel *)contentLb{
    
    if (!_contentLb) {
        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _contentLb;
}
- (UILabel *)timeLb{
    
    if (!_timeLb) {
        _timeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"" font:defaultFont(14) textInCenter:NO];
    }
    return _timeLb;
}
- (UILabel *)moneyLb{
    
    if (!_moneyLb) {
        _moneyLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _moneyLb;
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
