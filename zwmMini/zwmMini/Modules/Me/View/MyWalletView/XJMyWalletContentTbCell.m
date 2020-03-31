//
//  XJMyWalletContentTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyWalletContentTbCell.h"

@interface XJMyWalletContentTbCell()


@property(nonatomic,strong) UIView *leftView;
@property(nonatomic,strong) UIView *rightView;
@property(nonatomic,strong) UILabel *accountBlanceLb;
@property(nonatomic,strong) UILabel *coninLb;


@end

@implementation XJMyWalletContentTbCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = defaultLineColor;
        

        self.leftView.frame = CGRectMake(0, 5, kScreenWidth/2.f-2.5, 102);
        [self.leftView cornerRadiusViewWithRadius:5 andTopLeft:NO andTopRight:YES andBottomLeft:NO andBottomRight:YES];

        self.rightView.frame = CGRectMake(kScreenWidth/2.f+2.5, 5, kScreenWidth/2.f-2.5, 102);
        [self.rightView cornerRadiusViewWithRadius:5 andTopLeft:YES andTopRight:NO andBottomLeft:YES andBottomRight:NO];

        
        UIButton *blanceBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.leftView backColor:defaultWhite nomalTitle:@"收入余额" titleColor:defaultBlack titleFont:defaultFont(17) nomalImageName:@"balnceimg" selectImageName:@"" target:nil action:nil];
        [blanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftView).offset(20);
            make.centerX.equalTo(self.leftView);
            make.height.mas_equalTo(24);
        }];
        [blanceBtn setImage:GetImage(@"balnceimg") forState:UIControlStateDisabled];

        blanceBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-5, 0, 0);
        blanceBtn.enabled = NO;
        
        [self.accountBlanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(blanceBtn);
            make.top.equalTo(blanceBtn.mas_bottom).offset(10);
        }];
        
        UIButton *coinBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.rightView backColor:defaultWhite nomalTitle:@"么币余额" titleColor:defaultBlack titleFont:defaultFont(17) nomalImageName:@"coinimg" selectImageName:@"" target:nil action:nil];
        [coinBtn setImage:GetImage(@"coinimg") forState:UIControlStateDisabled];
        [coinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightView).offset(20);
            make.centerX.equalTo(self.rightView);
            make.height.mas_equalTo(24);
        }];
        coinBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-5, 0, 0);
        coinBtn.enabled = NO;


        [self.coninLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(coinBtn);
            make.top.equalTo(coinBtn.mas_bottom).offset(10);
        }];
        
    }
    return self;
    
}
- (void)setUpContent:(XJUserModel *)model{
    
    self.accountBlanceLb.text = [NSString stringWithFormat:@"￥%.2f",model.balance];
    self.coninLb.text = [NSString stringWithFormat:@"%ld",model.mcoin];
    
}

- (void)leftAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBlance)]) {
        [self.delegate clickBlance];
    }
    
    
}

- (void)rigthtAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCoin)]) {
        [self.delegate clickCoin];
    }
    
    
}



- (UIView *)leftView{
    
    if (!_leftView) {
        _leftView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
        UITapGestureRecognizer *leftTab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)];
        [_leftView addGestureRecognizer:leftTab];
    }
    return _leftView;
    
}
- (UIView *)rightView{
    
    if (!_rightView) {
        _rightView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
        UITapGestureRecognizer *rigthtTab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rigthtAction)];
        [_rightView addGestureRecognizer:rigthtTab];
    }
    return _rightView;
    
}

- (UILabel *)accountBlanceLb{
    if (!_accountBlanceLb) {
        _accountBlanceLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.leftView textColor:defaultGray text:@"" font:defaultFont(15) textInCenter:YES];
    }
    return _accountBlanceLb;
    
}
- (UILabel *)coninLb{
    if (!_coninLb) {
        _coninLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.rightView textColor:defaultGray text:@"" font:defaultFont(15) textInCenter:YES];
    }
    return _coninLb;
    
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
