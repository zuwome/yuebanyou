//
//  XJLoginView.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJLoginView.h"
#import "TYAttributedLabel.h"
#import "ZZProtocalChooseView.h"

@interface XJLoginView() <TYAttributedLabelDelegate>

@property(nonatomic,strong) UIView *gradienView;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UIButton *msgLogintBtn;
@property(nonatomic,strong) UIButton *forgetPsBtn;
@property(nonatomic,strong) UIButton  *eysBtn;
@property(nonatomic,strong) UILabel *pstitleLb;
@property(nonatomic,strong) UILabel *explainLb;
@property(nonatomic,strong) UIView *sedMsggradienView;
@property(nonatomic,strong) UIButton *sendMsgBtn;





@end

@implementation XJLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = defaultWhite;
        [self.areaCodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(90);
            make.left.equalTo(self).offset(30);
        }];
        
        UIImageView *downiv = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self imageUrl:@"" placehoderImage:@"downimg"];
        [downiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.areaCodeLb);
            make.left.equalTo(self.areaCodeLb.mas_right).offset(6);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(4);
        }];
        downiv.userInteractionEnabled = YES;
        UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaCodeAction)];
        [downiv addGestureRecognizer:areaTap];
        
        [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.areaCodeLb);
            make.left.equalTo(downiv.mas_right).offset(12);
            make.width.mas_equalTo(200);
        }];
        
        UIView *line1 = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneTF.mas_bottom).offset(10);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(1);
        }];
   
        [self.pstitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.areaCodeLb);
            make.top.equalTo(line1.mas_bottom).offset(34);
        }];
        [self.pswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pstitleLb);
            make.left.right.equalTo(self.phoneTF);
        }];
        
        UIView *line2 = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pswordTF.mas_bottom).offset(10);
            make.left.height.right.equalTo(line1);
        }];
        
        
        [self.eysBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pswordTF);
            make.right.equalTo(self).offset(-30);
            make.width.height.mas_equalTo(22);
        }];
        [self.explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2.mas_bottom).offset(5);
            make.left.equalTo(line2);
        }];
        
        [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_explainLb.mas_bottom).offset(5);
            make.left.equalTo(line2);
            make.right.equalTo(self).offset(-15);
        }];
        
//        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_explainLb.mas_bottom).offset(5);
//            make.left.equalTo(line2);
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
//
//        [self.registAgreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.selectBtn).offset(1);
//            make.leading.equalTo(self.selectBtn.mas_trailing).offset(5);
//            make.width.mas_equalTo(250);
//            make.height.mas_equalTo(20);
//        }];
        
        [self.gradienView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(line2.mas_bottom).offset(150);
            make.width.mas_equalTo(315);
            make.height.mas_equalTo(60);
        }];
        
        [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.gradienView);
        }];
        
        [self.msgLogintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.loginBtn);
            make.top.equalTo(self.loginBtn.mas_bottom).offset(11);
        }];
        
        [self.forgetPsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.loginBtn);
            make.top.equalTo(self.loginBtn.mas_bottom).offset(11);
        }];
        
        [self.sedMsggradienView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.pswordTF);
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

//更换区号
- (void)areaCodeAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAreaCode)]) {
        
        [self.delegate selectAreaCode];
    }
   
}

- (void)phoneTextChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneText:)]) {
        
        [self.delegate phoneText:tf.text];
    }
}
- (void)pswordTextChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordText:)]) {
        
        [self.delegate passwordText:tf.text];
    }
}

//同意用户协议
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"《用户使用和隐私协议》"]) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickUserProtocal)]) {
                [self.delegate  clickUserProtocal];
            }
            
        }
    }
}

- (void)select:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (_delegate && [_delegate respondsToSelector:@selector(agreeTheProtocol:)]) {
        [_delegate agreeTheProtocol:sender.isSelected];
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
//登录
- (void)logintAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomalLogin)]) {
        
        [self.delegate nomalLogin];
    }
    
    
}
//验证码登录
- (void)msgLogintAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(msgLogin)]) {
        
        [self.delegate msgLogin];
    }
}
//忘记密码
- (void)forgetAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgetPassword)]) {
        
        [self.delegate forgetPassword];
    }
    
}
//发送验证码
- (void)sendMsgAction:(UIButton *)btn{
    
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(senLoginMsg:)]) {
            
            [self.delegate senLoginMsg:btn];
        }
    
}



- (void)setIsmsgLogin:(BOOL)ismsgLogin{
    _ismsgLogin = ismsgLogin;
    self.msgLogintBtn.hidden = ismsgLogin;
    self.forgetPsBtn.hidden = ismsgLogin;
    self.eysBtn.hidden = ismsgLogin;
    self.explainLb.hidden = !ismsgLogin;
    self.sendMsgBtn.hidden = !ismsgLogin;
    self.sedMsggradienView.hidden = !ismsgLogin;

    if (ismsgLogin) {
        [self.loginBtn setTitle:@"验证并登录" forState:UIControlStateNormal];
        self.pstitleLb.text = @"验证码";
        self.pswordTF.placeholder = @"请输入验证码";
        
        [self.protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_explainLb.mas_bottom).offset(5);
        }];
        
    }else{
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        self.pstitleLb.text = @"密码";
        self.pswordTF.placeholder = @"6-16字母和数字组合";
        
        [self.protocolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_explainLb);
        }];
    }
    
}




#pragma mark lazy
- (UILabel *)areaCodeLb{
    if (!_areaCodeLb) {
        
        _areaCodeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"+86" font:defaultFont(17) textInCenter:NO];
        _areaCodeLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaCodeAction)];
        [_areaCodeLb addGestureRecognizer:areaTap];
    }
    return _areaCodeLb;
}
- (UILabel *)pstitleLb{
    
    if (!_pstitleLb) {
        
        _pstitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"密码" font:defaultFont(17) textInCenter:NO];
        
    }
    return _pstitleLb;
    
}
- (UILabel *)explainLb{
    if (!_explainLb) {
        
        _explainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:RGB(153, 153, 153) text:@"未注册的手机将自动创建账号" font:defaultFont(13) textInCenter:NO];
     
    }
    return _explainLb;
}

- (UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入手机号" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneTF addTarget:self action:@selector(phoneTextChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _phoneTF;
    
}
- (UITextField *)pswordTF{
    if (!_pswordTF) {
        
        _pswordTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"6-16字母和数字组合" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _pswordTF.secureTextEntry = YES;
         [_pswordTF addTarget:self action:@selector(pswordTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pswordTF;
    
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
       
        
        
        _loginBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.gradienView backColor:defaultClearColor nomalTitle:@"登录" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(logintAction)];

  
    }
    return _loginBtn;
    
    
}
- (UIButton *)msgLogintBtn{
    if (!_msgLogintBtn) {
        
        _msgLogintBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultWhite nomalTitle:@"验证码登录" titleColor:RGB(153, 153, 153) titleFont:defaultFont(14) nomalImageName:nil selectImageName:nil target:self action:@selector(msgLogintAction)];
    }
    return _msgLogintBtn;
    
}
- (UIButton *)eysBtn{
    if (!_eysBtn) {
        
        _eysBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"biyan" selectImageName:@"zhengyan" target:self action:@selector(eysBtnAction:)];
        
    }
    return _eysBtn;
    
}
- (UIButton *)forgetPsBtn{
    if (!_forgetPsBtn) {
        
        _forgetPsBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultWhite nomalTitle:@"忘记密码" titleColor:RGB(153, 153, 153) titleFont:defaultFont(14) nomalImageName:nil selectImageName:nil target:self action:@selector(forgetAction)];
    }
    return _forgetPsBtn;
    
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

- (ZZProtocalChooseView *)protocolView{
    if (!_protocolView) {
        _protocolView = [[ZZProtocalChooseView alloc] initWithFrame:CGRectMake(20, 0.0 + 8, kScreenWidth - 40, 25) isLogin:YES];
        [self addSubview:_protocolView];
        
        @WeakObj(self);
        _protocolView.touchProtocal = ^{
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(clickUserPrivateProtocal)]) {
                [weakself.delegate clickUserPrivateProtocal];
            }
        };
        
        _protocolView.touchPrivate = ^{
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(clickUserProtocal)]) {
                [weakself.delegate clickUserProtocal];
            }
        };
        
        _protocolView.touchSelectedBlock = ^(BOOL isSeleceted) {
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(agreeTheProtocol:)]) {
                [weakself.delegate agreeTheProtocol:isSeleceted];
            }
        };
    }
    return _protocolView;
}

@end
