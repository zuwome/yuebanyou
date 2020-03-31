//
//  XJRestPasswordView.m
//  zwmMini
//
//  Created by Batata on 2018/11/22.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRestPasswordView.h"


@interface XJRestPasswordView ()

@property(nonatomic,strong) UIView *gradienView;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UIButton  *eysBtn;
@property(nonatomic,strong) UILabel *pstitleLb;
@property(nonatomic,strong) UILabel *msgcodetitleLb;
@property(nonatomic,strong) UIView *sedMsggradienView;
@property(nonatomic,strong) UIButton *sendMsgBtn;
@property(nonatomic,strong) UITextField *pswordTF;
@property(nonatomic,strong) UITextField *msgCodeTF;

@end

@implementation XJRestPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = defaultWhite;
        
      
        
        [self.msgcodetitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(90);
            make.left.equalTo(self).offset(30);
           
        }];
        [self.msgCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.msgcodetitleLb);
            make.left.equalTo(self.msgcodetitleLb.mas_right).offset(12);
            make.width.mas_equalTo(200);
        }];
        
        UIView *line1 = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.msgCodeTF.mas_bottom).offset(10);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(1);
        }];
        
        
        [self.pstitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.msgcodetitleLb);
            make.top.equalTo(line1.mas_bottom).offset(34);
        }];
        
        
        [self.pswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pstitleLb);
            make.left.right.equalTo(self.msgCodeTF);
        }];
        
        [self.eysBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pswordTF);
            make.right.equalTo(self).offset(-30);
            make.width.height.mas_equalTo(22);
        }];
        
        UIView *line2 = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.msgCodeTF.mas_bottom).offset(10);
            make.left.height.right.equalTo(line1);
            
        }];
        
        [self.gradienView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(line2.mas_bottom).offset(150);
            make.width.mas_equalTo(315);
            make.height.mas_equalTo(60);
        }];
        
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.gradienView);
        }];
        
        
        [self.sedMsggradienView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.msgCodeTF);
            make.right.equalTo(line2);
            make.width.mas_equalTo(67);
            make.height.mas_equalTo(32);
        }];
        [self.sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.sedMsggradienView);
        }];
        
    }
    return self;
}


- (void)msgTextChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(msgText:)]) {
        
        [self.delegate msgText:tf.text];
    }
}
- (void)pswordTextChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordnText:)]) {
        
        [self.delegate passwordnText:tf.text];
    }
}


//显示密码
- (void)eysBtnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        self.pswordTF.secureTextEntry = NO;
    }else{
        self.pswordTF.secureTextEntry = YES;
    }
    
}
//重置密码
- (void)logintAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetPassword)]) {
        
        [self.delegate resetPassword];
    }
    
    
}

//发送验证码
- (void)sendMsgAction:(UIButton *)btn{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(senLoginMsg:)]) {
        
        [self.delegate senLoginMsg:btn];
    }
    
}




#pragma mark lazy


- (UILabel *)pstitleLb{
    
    if (!_pstitleLb) {
        
        _pstitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"密码" font:defaultFont(17) textInCenter:NO];
        
    }
    return _pstitleLb;
    
}


- (UILabel *)msgcodetitleLb{
    
    if (!_msgcodetitleLb) {
        
        _msgcodetitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"验证码" font:defaultFont(17) textInCenter:NO];
        
    }
    return _msgcodetitleLb;
    
}


- (UITextField *)pswordTF{
    if (!_pswordTF) {
        _pswordTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入新密码" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _pswordTF.keyboardType = UIKeyboardTypeNumberPad;
        [_pswordTF addTarget:self action:@selector(pswordTextChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _pswordTF;
    
}
- (UITextField *)msgCodeTF{
    if (!_msgCodeTF) {
        
        _msgCodeTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入验证码" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _msgCodeTF.secureTextEntry = YES;
        [_msgCodeTF addTarget:self action:@selector(msgTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _msgCodeTF;
    
}

- (UIView *)gradienView{
    
    if (!_gradienView) {
        
        _gradienView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 60)];
        [_gradienView.layer addSublayer:gradientLayer];
        _gradienView.layer.cornerRadius = 30;
        _gradienView.layer.masksToBounds = YES;
    }
    return _gradienView;
}
- (UIButton *)loginBtn{
    
    if (!_loginBtn) {
        
        
        
        _loginBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.gradienView backColor:defaultClearColor nomalTitle:@"确定" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(logintAction)];
        
        
    }
    return _loginBtn;
    
    
}

- (UIButton *)eysBtn{
    if (!_eysBtn) {
        
        _eysBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"biyan" selectImageName:@"zhengyan" target:self action:@selector(eysBtnAction:)];
        
    }
    return _eysBtn;
    
}

- (UIView *)sedMsggradienView{
    
    if (!_sedMsggradienView) {
        
        _sedMsggradienView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 67, 32)];
        [_sedMsggradienView.layer addSublayer:gradientLayer];
        _sedMsggradienView.layer.cornerRadius = 16;
        _sedMsggradienView.layer.masksToBounds = YES;
    }
    return _sedMsggradienView;
}
- (UIButton *)sendMsgBtn{
    if (!_sendMsgBtn) {
        
        _sendMsgBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultClearColor nomalTitle:@"发送" titleColor:defaultWhite titleFont:defaultFont(14) nomalImageName:nil selectImageName:nil target:self action:@selector(sendMsgAction:)];
    }
    return _sendMsgBtn;
    
}
@end
