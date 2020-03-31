//
//  XJRegistView.m
//  zwmMini
//
//  Created by Batata on 2018/11/16.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRegistView.h"
#import "TYAttributedLabel.h"
#import "ZZProtocalChooseView.h"
@interface XJRegistView()<UITextFieldDelegate,TYAttributedLabelDelegate>

@property(nonatomic,strong) UIView *gradienView;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UILabel *pstitleLb;
@property(nonatomic,strong) UIView *sedMsggradienView;
@property(nonatomic,strong) UIButton *sendMsgBtn;
@property (nonatomic, strong) ZZProtocalChooseView *protocolView;
@end

@implementation XJRegistView

- (instancetype)initWithFrame:(CGRect)frame
{
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
        
        [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2.mas_bottom).offset(5);
            make.left.equalTo(line2);
            make.right.equalTo(self).offset(-15);
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

- (void)select:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (_delegate && [_delegate respondsToSelector:@selector(agreeTheProtocol:)]) {
        [_delegate agreeTheProtocol:sender.isSelected];
    }
}

//更换区号
- (void)areaCodeAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAreaCode)]) {
        [self.delegate selectAreaCode];
    }
}

//登录
- (void)logintAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(nomalRegist)]) {
        [self.delegate nomalRegist];
    }
}


//发送验证码
- (void)sendMsgAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(senLoginMsg:)]) {
        [self.delegate senLoginMsg:btn];
    }
    
}
//手机号
- (void)phoneTextChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneText:)]) {
        
        [self.delegate  phoneText:tf.text];
    }
}
//验证码
- (void)pswordTextChange:(UITextField *)tf{
    if (self.delegate && [self.delegate respondsToSelector:@selector(msgcodText:)]) {
        
        [self.delegate  msgcodText:tf.text];
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
        
        _pstitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"验证码" font:defaultFont(17) textInCenter:NO];
        
    }
    return _pstitleLb;
    
}

- (UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入手机号" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.delegate = self;
        [_phoneTF addTarget:self action:@selector(phoneTextChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _phoneTF;
    
}
- (UITextField *)pswordTF{
    if (!_pswordTF) {
        
        _pswordTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入验证码" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _pswordTF.delegate = self;
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
        _loginBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.gradienView backColor:defaultClearColor nomalTitle:@"下一步" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(logintAction)];
    }
    return _loginBtn;
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
        _protocolView = [[ZZProtocalChooseView alloc] initWithFrame:CGRectMake(20, 0.0 + 8, kScreenWidth - 40, 25) isLogin:NO];
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
