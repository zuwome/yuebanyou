//
//  XJWithDarwInputMoneyTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJWithDarwInputMoneyTbCell.h"


@interface XJWithDarwInputMoneyTbCell()

@property(nonatomic,strong) UITextField *inputMoneyTf;

@end

@implementation XJWithDarwInputMoneyTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"提现金额" font:defaultFont(17) textInCenter:NO];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.top.equalTo(self.contentView).offset(15);
        }];
        UILabel *moneyLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"￥" font:defaultFont(20) textInCenter:NO];
        [moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.top.equalTo(titleLb.mas_bottom).offset(34);
        }];
       
        [self.inputMoneyTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyLb.mas_right).offset(10);
            make.centerY.equalTo(moneyLb);
            make.width.mas_equalTo(200);
        }];
        
    }
    
    return self;
    
}


- (void)inputMoneyt:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(moneyText:)]) {
        [self.delegate moneyText:tf.text];
    }
}
- (void)setUpInputFileText:(NSString *)text{
    
    self.inputMoneyTf.text = text;
    
}

- (UITextField *)inputMoneyTf{
    if (!_inputMoneyTf) {
        
        _inputMoneyTf = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"单笔最高提现2000元" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _inputMoneyTf.keyboardType = UIKeyboardTypeNumberPad;
        [_inputMoneyTf addTarget:self action:@selector(inputMoneyt:) forControlEvents:UIControlEventEditingChanged];
    }
    return _inputMoneyTf;
    
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
