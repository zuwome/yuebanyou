//
//  XJYoubiTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJYoubiTbCell.h"

@interface XJYoubiTbCell()

@property(nonatomic,strong) UIImageView *typeIV;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *moneyLb;

@end

@implementation XJYoubiTbCell

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



- (void)setUpContent:(XJSubYoubiRecordModel *)ymodel{
    
    self.moneyLb.text = [NSString stringWithFormat:@"%@么币",ymodel.amount];
    self.contentLb.text = ymodel.type_text;
    self.timeLb.text = ymodel.created_at_text;
    NSArray *types = @[@"qchat",@"chatcharge",@"systemSend",@"integralExchange",@"pay_for_wechat"];
    NSInteger index = [types indexOfObject:ymodel.type];
    switch (index) {
        case 0:
        {
            self.typeIV.image = GetImage(@"icShipin");
        }
            break;
        case 1:
        {
            self.typeIV.image = GetImage(@"icSixinZhangdanMebijilu");
        }
            break;
        case 2:
        {
            self.typeIV.image = GetImage(@"icXitongZhangdanMebijilu");
        }
            break;
        case 3:
        {
            self.typeIV.image = GetImage(@"icJifenWalletMbjl");
        }
            break;
        case 4:
        {
            self.typeIV.image = GetImage(@"wechatC");
        }
            break;
            
        default:
        {
            if ([ymodel.channel isEqualToString:@"in_app_purchase"]) {
                
                self.typeIV.image = GetImage(@"icApplePay");
            }else if ([ymodel.channel isEqualToString:@"wx_pub"] || [ymodel.channel isEqualToString:@"wx"]){
                
                self.typeIV.image = GetImage(@"wechatC");
            }else if ([ymodel.channel isEqualToString:@"alipay"]){
                self.typeIV.image = GetImage(@"alipayC");
            }else{
                
                self.typeIV.image = GetImage(@"icDefault");

            }
            
        }
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
