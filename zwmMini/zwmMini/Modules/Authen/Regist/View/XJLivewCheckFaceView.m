//
//  XJLivewCheckFaceView.m
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJLivewCheckFaceView.h"

@interface XJLivewCheckFaceView()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *bgIV;
//@property(nonatomic,strong) UIButton *skipBtn;
@property(nonatomic,strong) UIButton *beginCheckBtn;
@property(nonatomic,strong) UIView *begintCheckView;



@end

@implementation XJLivewCheckFaceView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgView);
        }];
        
        UILabel *explinLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultWhite text:@"为确保您的资料真实，保障您的人身及后续账户资金安全，将进行真人验证，请确保是您本人操作" font:defaultFont(15) textInCenter:YES];
        [explinLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.width.mas_equalTo(258);
            make.centerX.equalTo(self);
        }];
        explinLb.numberOfLines = 0;
        
        [self.begintCheckView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-45);
            make.width.mas_equalTo(315);
            make.height.mas_equalTo(60);
        }];
        [self.beginCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.begintCheckView);
        }];
//        [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.bottom.equalTo(self.begintCheckView.mas_top).offset(-20);
//        }];

    }
    return self;
}


- (void)setIsBoy:(BOOL)isBoy{
    _isBoy = isBoy;
//    self.skipBtn.hidden = !isBoy;
    
}

- (void)skipAction{
    
    if (self.clickSkip) {
        self.clickSkip();
    }
}
- (void)begincheckAction{
    if (self.clickBegin) {
        self.clickBegin();
    }
}

#pragma mark lazy


- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:RGBA(106, 73, 172, 1)];
    }
    return _bgView;
    
    
}
- (UIImageView *)bgIV{
    
    if (!_bgIV) {
        
        _bgIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@"beginchekimg"];
    }
    return _bgIV;
    
}

//- (UIButton *)skipBtn{
//    if (!_skipBtn) {
//        _skipBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultClearColor nomalTitle:@"跳过 >" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(skipAction)];
//
//    }
//
//    return _skipBtn;
//
//
//}
- (UIView *)begintCheckView{
    
    if (!_begintCheckView) {
        
        _begintCheckView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 60)];
        [_begintCheckView.layer addSublayer:gradientLayer];
        _begintCheckView.layer.cornerRadius = 30;
        _begintCheckView.layer.masksToBounds = YES;
    }
    return _begintCheckView;
}

- (UIButton *)beginCheckBtn{
    if (!_beginCheckBtn) {
        _beginCheckBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultClearColor nomalTitle:@"开始验证" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(begincheckAction)];
        
    }
    
    return _beginCheckBtn;
    
    
}

@end
