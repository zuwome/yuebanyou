//
//  XJChangePsView.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJChangePsView.h"

@interface XJChangePsView()

@property(nonatomic,strong) UIButton  *eysoldBtn;
@property(nonatomic,strong) UIButton  *eysnewBtn;
@property(nonatomic,strong) UILabel *otitleLb;
@property(nonatomic,strong) UILabel *ntitleLb;
@property(nonatomic,strong) UITextField *oPasswTf;
@property(nonatomic,strong) UITextField *nPasswTf;



@end

@implementation XJChangePsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = defaultWhite;
        [self.otitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self).offset(15);
        }];
        [self.oPasswTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.otitleLb);
            make.left.equalTo(self.otitleLb.mas_right).offset(10);
            make.width.mas_equalTo(250);
        }];
        [self.eysoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-30);
            make.centerY.equalTo(self.oPasswTf);
            make.width.height.mas_equalTo(22);
        }];
        
        UIView *lineV = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];
        [self addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.oPasswTf.mas_bottom).offset(15);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(10);
        }];
        
        [self.ntitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineV.mas_bottom).offset(15);
            make.left.equalTo(self).offset(15);
        }];
        [self.nPasswTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.ntitleLb);
            make.left.equalTo(self.otitleLb.mas_right).offset(10);
            make.width.mas_equalTo(250);
        }];
        [self.eysnewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-30);
            make.centerY.equalTo(self.nPasswTf);
            make.width.height.mas_equalTo(22);
        }];
        
        
        
    }
    return self;
}



- (void)oldPwTextChange:(UITextField *)tf{
    if (self.delegate && [self.delegate respondsToSelector:@selector(oldPassText:)]) {
        [self.delegate oldPassText:tf.text];
    }
    
}
- (void)newPwTextChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(newPassText:)]) {
        [self.delegate newPassText:tf.text];
    }
}
- (void)eysOldBtnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    _oPasswTf.secureTextEntry = !btn.selected;

    
}
- (void)eysNewBtnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    _nPasswTf.secureTextEntry = !btn.selected;
}


#pragma mark lazy
- (UILabel *)otitleLb{
    
    if (!_otitleLb) {
        
        _otitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"旧密码" font:defaultFont(17) textInCenter:NO];
        
    }
    return _otitleLb;
    
}
- (UILabel *)ntitleLb{
    
    if (!_ntitleLb) {
        
        _ntitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"新密码" font:defaultFont(17) textInCenter:NO];
        
    }
    return _ntitleLb;
    
}
- (UITextField *)oPasswTf{
    if (!_oPasswTf) {
        
        _oPasswTf = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入旧密码" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _oPasswTf.secureTextEntry = YES;
        [_oPasswTf addTarget:self action:@selector(oldPwTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oPasswTf;
    
}
- (UITextField *)nPasswTf{
    if (!_nPasswTf) {
        
        _nPasswTf = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输新密码" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _nPasswTf.secureTextEntry = YES;
        [_nPasswTf addTarget:self action:@selector(newPwTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nPasswTf;
    
}
- (UIButton *)eysoldBtn{
    if (!_eysoldBtn) {
        
        _eysoldBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"biyan" selectImageName:@"zhengyan" target:self action:@selector(eysOldBtnAction:)];
        
    }
    return _eysoldBtn;
    
}
- (UIButton *)eysnewBtn{
    if (!_eysnewBtn) {
        
        _eysnewBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"biyan" selectImageName:@"zhengyan" target:self action:@selector(eysNewBtnAction:)];
        
    }
    return _eysnewBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
