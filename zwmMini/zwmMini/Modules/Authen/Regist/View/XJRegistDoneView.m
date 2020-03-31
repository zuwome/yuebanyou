//
//  XJRegistDoneView.m
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRegistDoneView.h"

@interface XJRegistDoneView()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *headExplainLb;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *wechatLb;
@property(nonatomic,strong) UILabel *wchatExplainLb;
@property(nonatomic,strong) UIView *doneBackView;
@property(nonatomic,strong) UIButton *dongBtn;
@property(nonatomic,strong) UITextField *nameTf;
@property(nonatomic,strong) UITextField *wechatTf;
@property(nonatomic,strong) UIView *line1;
@property(nonatomic,strong) UIView *line2;





@end

@implementation XJRegistDoneView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = defaultWhite;
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(27);
            make.centerX.equalTo(self);
            make.width.height.mas_equalTo(140);
        }];
        self.headIV.layer.cornerRadius = 70;
        self.headIV.layer.masksToBounds = YES;
        
        [self.headExplainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headIV.mas_bottom).offset(25);
            make.centerX.equalTo(self.headIV);
            make.left.equalTo(self).offset(76);
            make.right.equalTo(self).offset(-76);
        }];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.top.equalTo(self.headExplainLb.mas_bottom).offset(68);
            make.width.mas_equalTo(70);
        }];
        
        [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.left.equalTo(self.nameLb.mas_right).offset(5);
            make.right.equalTo(self).offset(-30);
        }];
        
        [self.wechatLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.nameLb);
            make.top.equalTo(self.nameLb.mas_bottom).offset(37);
            
        }];
        [self.wechatTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wechatLb);
            make.left.equalTo(self.wechatLb.mas_right).offset(5);
            make.right.equalTo(self).offset(-30);

        }];
        [self.wchatExplainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wechatLb.mas_bottom).offset(12);
            make.left.equalTo(self.wechatLb);
            make.right.equalTo(self.wechatTf);
        }];
        
        [self.doneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-45);
            make.width.mas_equalTo(315);
            make.height.mas_equalTo(60);
        }];
        [self.dongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.doneBackView);
        }];
        
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameTf.mas_bottom).offset(5);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(1);
        }];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wechatTf.mas_bottom).offset(5);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}



- (void)setIsBoy:(BOOL)isBoy{
    _isBoy =isBoy;
    self.wchatExplainLb.hidden = isBoy;
    self.wechatTf.hidden = isBoy;
    self.wechatLb.hidden = isBoy;
    self.line2.hidden = isBoy;
    
}


- (void)tapIV{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHeadIV:)]) {
        [self.delegate clickHeadIV:self.headIV];
    }
    
}

- (void)nameTfChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(nameText:)]) {
        [self.delegate nameText:tf.text];
    }
    
    
}
- (void)wechatTfChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wechatText:)]) {
        [self.delegate wechatText:tf.text];
    }
    
}

- (void)doneAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDone)]) {
        [self.delegate clickDone];
    }
    
    
}




#pragma mark lazy
- (UIImageView *)headIV{
    
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self imageUrl:@"" placehoderImage:@"morentouxiang"];
        _headIV.backgroundColor = defaultLineColor;
        _headIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapIV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIV)];
        [_headIV addGestureRecognizer:tapIV];
        
    }
    return _headIV;
    
}
- (UILabel *)headExplainLb{
    
    if (!_headExplainLb) {
        _headExplainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"请上传你颜值最高的真实照片作为头像伴友会对你头像颜值进行检测推荐哦" font:defaultFont(13) textInCenter:YES];
        _headExplainLb.numberOfLines = 0;
        
    }
    return _headExplainLb;
    
}
- (UILabel *)nameLb{
    
    if (!_nameLb) {
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"昵称" font:defaultFont(17) textInCenter:NO];
        
    }
    return _nameLb;
    
}
- (UILabel *)wechatLb{
    
    if (!_wechatLb) {
        _wechatLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"微信号:" font:defaultFont(17) textInCenter:NO];
        
    }
    return _wechatLb;
    
}
- (UILabel *)wchatExplainLb{
    
    if (!_wchatExplainLb) {
        _wchatExplainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultGray text:@"填写自己微信号以供Ta人付费查看，获得收益的同时，也帮您过滤掉不必要的骚扰" font:defaultFont(13) textInCenter:YES];
        _wchatExplainLb.numberOfLines = 0;

        
    }
    return _wchatExplainLb;
    
}
- (UITextField *)nameTf{
    if (!_nameTf) {
    
        _nameTf = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入您的昵称" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
         [_nameTf addTarget:self action:@selector(nameTfChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _nameTf;
}
- (UITextField *)wechatTf{
    if (!_wechatTf) {
        
        _wechatTf = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请填写您的微信号" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        [_wechatTf addTarget:self action:@selector(wechatTfChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _wechatTf;
}

- (UIView *)doneBackView{
    
    if (!_doneBackView) {
        
        _doneBackView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultGray];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 60)];
        [_doneBackView.layer addSublayer:gradientLayer];
        _doneBackView.layer.cornerRadius = 30;
        _doneBackView.layer.masksToBounds = YES;
    }
    return _doneBackView;
}
- (UIButton *)dongBtn{
    
    if (!_dongBtn) {
        _dongBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.doneBackView backColor:defaultClearColor nomalTitle:@"完成" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(doneAction)];
    }
    
    return _dongBtn;
    
    
}
- (UIView *)line1{
    
    if (!_line1) {
         _line1 = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];
    }
    return _line1;
}
- (UIView *)line2{
    
    if (!_line2) {
        _line2 = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];

    }
    return _line2;
}
@end
