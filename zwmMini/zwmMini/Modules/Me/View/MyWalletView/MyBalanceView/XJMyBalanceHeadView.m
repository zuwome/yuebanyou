//
//  XJMyBalanceHeadView.m
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyBalanceHeadView.h"

@interface XJMyBalanceHeadView()

@property(nonatomic,strong) UILabel *balanceLb;
@property(nonatomic,strong) UILabel *frozenLb;


@end
@implementation XJMyBalanceHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = defaultWhite;
        UILabel *balacntitleLB = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:[UIColor blackColor] text:@"账户余额(元)" font:defaultFont(14) textInCenter:NO];
        [balacntitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(23);
            make.left.equalTo(self).offset(15);
        }];
        [self.balanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balacntitleLB);
            make.top.equalTo(balacntitleLB.mas_bottom).offset(11);
        }];
        
        UILabel *frotitleLB = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:RGB(51, 51, 51) text:@"锁定余额(元):" font:defaultFont(14) textInCenter:NO];
        [frotitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceLb.mas_bottom).offset(11);
            make.left.equalTo(self).offset(15);
        }];
        
        [self.frozenLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(frotitleLB);
            make.left.equalTo(frotitleLB.mas_right).offset(5);
        }];
        
        UILabel *hintLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultGray text:@"锁定余额为支付/提现时待审核的金额" font:defaultFont(11) textInCenter:NO];
        [hintLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.frozenLb.mas_bottom).offset(11);
            make.left.equalTo(self).offset(15);
        }];
    }
    return self;
}



- (void)setModel:(XJCoinModel *)model{
    
    self.balanceLb.text = [NSString stringWithFormat:@"%.2f",model.balance];
    self.frozenLb.text = [NSString stringWithFormat:@"%.2f",model.frozen];
}


- (UILabel *)balanceLb{
    if (!_balanceLb) {
        _balanceLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:RGB(255, 87, 103) text:@"0.00" font:defaultFont(48.0) textInCenter:NO];
    }
    return _balanceLb;
    
}
- (UILabel *)frozenLb{
    if (!_frozenLb) {
        _frozenLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:RGB(51, 51, 51) text:@"" font:defaultFont(14) textInCenter:NO];
    }
    return _frozenLb;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
