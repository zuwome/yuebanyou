//
//  XJMyCoinCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyCoinCollectionViewCell.h"


@interface XJMyCoinCollectionViewCell()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *coinLb;
@property(nonatomic,strong) UILabel *moneyLb;




@end

@implementation XJMyCoinCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(64);
        }];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.borderColor = defaultBlack.CGColor;
        self.bgView.layer.borderWidth = 1;
        
        [self.coinLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.equalTo(self.bgView).offset(10);
        }];
        [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.bottom.equalTo(self.bgView).offset(-10);
        }];
       
    }
    return self;
    
}


- (void)setUpContet:(XJPayCoinModel *)pmodel isSelect:(BOOL)select{

    self.coinLb.text = [NSString stringWithFormat:@"%ld么币",pmodel.mcoin];
    self.moneyLb.text = [NSString stringWithFormat:@"%ld元",pmodel.money];
    
    if (select) {
        self.bgView.layer.borderColor = RGB(254, 83, 108).CGColor;
        self.bgView.backgroundColor = RGB(254, 83, 108);
        self.coinLb.textColor = defaultWhite;
        self.moneyLb.textColor = defaultWhite;
        
    }else{
        self.bgView.layer.borderColor = defaultBlack.CGColor;
        self.bgView.backgroundColor = defaultWhite;
        self.coinLb.textColor = defaultBlack;
        self.moneyLb.textColor = defaultGray;
    }
    
}



#pragma mark lazy

- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
    }
    return _bgView;
    
}
- (UILabel *)coinLb{
    
    if (!_coinLb) {
        _coinLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:YES];
    }
    return _coinLb;
    
}

- (UILabel *)moneyLb{
    
    if (!_moneyLb) {
        _moneyLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultGray text:@"" font:defaultFont(15) textInCenter:YES];
    }
    return _moneyLb;
    
}
@end
