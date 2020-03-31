//
//  XJFirstOpenChatHintVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/17.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJFirstOpenChatHintVC.h"

@interface XJFirstOpenChatHintVC ()

@property(nonatomic,strong) UIView *backView;
@property(nonatomic,strong) UIImageView *titleIV;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *moneyLb;
@property(nonatomic,strong) UIButton *okBtn;






@end

@implementation XJFirstOpenChatHintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self creatUI];

}

- (void)creatUI{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(286);
    }];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.backView);
        make.width.height.mas_equalTo(30);
    }];
    [self.titleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(20);
        make.width.mas_equalTo(174);
        make.height.mas_equalTo(98);
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleIV.mas_bottom).offset(18);
        make.left.equalTo(self.backView).offset(15);
        make.right.equalTo(self.backView).offset(-15);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.titleLb.mas_bottom).offset(13);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
    }];
    self.okBtn.layer.cornerRadius = 22;
    self.okBtn.layer.masksToBounds = YES;
    
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.okBtn.mas_bottom).offset(5);
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-10);
    }];
    if (!self.isNeedCharge) {
        self.moneyLb.hidden = YES;
    }
}



- (void)closeAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma makr lazy


- (UIView *)backView{
    if (!_backView) {
        
        _backView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
    }
    return _backView;
}
- (UIImageView *)titleIV{
    if (!_titleIV) {
        
        NSString *imgstr = self.isNeedCharge ? @"picNan":@"picNv";
        _titleIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.backView imageUrl:nil placehoderImage:imgstr];
    }
    return _titleIV;
    
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.backView backColor:defaultClearColor nomalTitle:@"" titleColor:defaultWhite titleFont:nil nomalImageName:@"daximg" selectImageName:nil target:self action:@selector(closeAction)];
    }
    return _closeBtn;
}
- (UILabel *)titleLb{
    
    if (!_titleLb) {
        NSString *titlestr = self.isNeedCharge ? @"为了提高Ta的回复率，需要向对方赠送2张私信卡":@"为了减少无效骚扰，已为您开启私信收益功能，收到每条私信获得2张私信卡，24小时内回复领取私信卡可获得0.2元收益";
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.backView textColor:defaultBlack text:titlestr font:defaultFont(15) textInCenter:YES];
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

- (UIButton *)okBtn{
    
    if (!_okBtn) {
        _okBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.backView backColor:defaultRedColor nomalTitle:@"知道了" titleColor:defaultWhite titleFont:defaultFont(15) nomalImageName:nil selectImageName:nil target:self action:@selector(closeAction)];
    }
    return _okBtn;
}

- (UILabel *)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [XJUIFactory creatUILabelWithFrame:CGRectZero
                                            addToView:self.backView
                                            textColor:defaultBlack
                                                 text:@"一张私信卡=2么币"
                                                 font:defaultFont(13)
                                         textInCenter:YES];
    }
    return _moneyLb;
}

@end
