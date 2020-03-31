//
//  ZZProtocalChooseView.m
//  zuwome
//
//  Created by angBiu on 2016/11/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZProtocalChooseView.h"

@implementation ZZProtocalChooseView
{
    UIImageView *_imgView;
}

- (instancetype)initWithFrame:(CGRect)frame isLogin:(BOOL)islogin
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _isLogin = islogin;
        _isSelected = NO;
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"btn_report_n"];
        [self addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        NSString *title = nil;
        if (_isLogin) {
            title = @"登录即同意";
        }
        else {
            title = @"注册即同意";
        }
        
        NSString *didChecked = [[NSUserDefaults standardUserDefaults] objectForKey:@"didLoginChecked"];
        if (!NULLString(didChecked) && _isLogin) {
            _isSelected = YES;
            _imgView.image = [UIImage imageNamed:@"btn_report_p"];
            if (_touchSelectedBlock) {
                _touchSelectedBlock(YES);
            }
        }
        UILabel *titleLabel = [self createLabelWithAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x808080) fontSize:12 text:title];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UILabel *protocalLabel = [self createLabelWithAlignment:NSTextAlignmentLeft textColor:kYellowColor fontSize:12 text:@"《租我吗用户协议》"];
        [self addSubview:protocalLabel];
        [protocalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    
        NSString *str = @"和《租我吗隐私权政策》";
        UILabel *privateLabel = [self createLabelWithAlignment:NSTextAlignmentLeft textColor:kYellowColor fontSize:12 text:str];
        
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x808080) range:NSMakeRange(0, str.length)];
        
        NSRange range = [str rangeOfString:@"《租我吗隐私权政策》"];
        if (range.location != NSNotFound) {
            [attriStr addAttribute:NSForegroundColorAttributeName value:kYellowColor range:range];
        }
        privateLabel.attributedText = attriStr;
        privateLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPrivateProtocol)];
        [privateLabel addGestureRecognizer:tap];
        
        [self addSubview:privateLabel];
        [privateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(protocalLabel.mas_right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(titleLabel.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        UIButton *protocalBtn = [[UIButton alloc] init];
        [protocalBtn addTarget:self action:@selector(protocalBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:protocalBtn];
        
        [protocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(protocalLabel);
        }];
        
        
    }
    
    return self;
}

- (void)btnClick
{
    if (_isSelected) {
        _isSelected = NO;
        _imgView.image = [UIImage imageNamed:@"btn_report_n"];
        if (_isLogin) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"didLoginChecked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        _isSelected = YES;
        _imgView.image = [UIImage imageNamed:@"btn_report_p"];
        if (_isLogin) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"didLoginChecked"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (_touchSelectedBlock) {
        _touchSelectedBlock(_isSelected);
    }
}

- (void)protocalBtnClick
{
    if (_touchProtocal) {
        _touchProtocal();
    }
}

- (void)showPrivateProtocol {
    if (_touchPrivate) {
        _touchPrivate();
    }
}

- (UILabel *)createLabelWithAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = text;
    
    return label;
}

@end
