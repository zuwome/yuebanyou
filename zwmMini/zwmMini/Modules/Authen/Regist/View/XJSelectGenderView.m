//
//  XJSelectGenderView.m
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSelectGenderView.h"

@interface XJSelectGenderView()

@property(nonatomic,strong) UIButton *boyBtn;
@property(nonatomic,strong) UIButton *girlBtn;
@property(nonatomic,strong) UIButton *sureBtn;


@end

@implementation XJSelectGenderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLb = [XJUIFactory creatUILabelWithFrame:CGRectMake(30, SafeAreaTopHeight+10, 150, 50) addToView:self textColor:defaultBlack text:@"你的性别" font:defaultFont(29) textInCenter:NO];
        UILabel *explainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultGray text:@"注册成功后不可修改哦" font:defaultFont(16) textInCenter:NO];
        [explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLb);
            make.top.equalTo(titleLb.mas_bottom).offset(10);
        }];
        
        [self.boyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLb);
            make.top.equalTo(explainLb.mas_bottom).offset(60);
            make.width.height.mas_equalTo(140);
        }];
//        self.boyBtn.layer.cornerRadius = 70;
//        self.boyBtn.layer.masksToBounds = YES;
        
        
        [self.girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(explainLb.mas_bottom).offset(60);
            make.width.height.mas_equalTo(140);
        }];
//        self.girlBtn.layer.cornerRadius = 70;
//        self.girlBtn.layer.masksToBounds = YES;
        
         UILabel *boyLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:RGB(102, 102, 102) text:@"男" font:defaultFont(16) textInCenter:NO];
        [boyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.boyBtn.mas_bottom).offset(16);
            make.centerX.equalTo(self.boyBtn);
        }];
        
        UILabel *girlLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:RGB(102, 102, 102) text:@"女" font:defaultFont(16) textInCenter:NO];
        [girlLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.boyBtn.mas_bottom).offset(16);
            make.centerX.equalTo(self.girlBtn);
        }];
        
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-40);
            make.bottom.equalTo(self).offset(-50);
            make.width.height.mas_equalTo(75);
            
        }];
//        self.sureBtn.layer.cornerRadius = 37.5;
//        self.sureBtn.layer.masksToBounds = YES;
        [self.sureBtn setBackgroundImage:GetImage(@"gendersure") forState:UIControlStateNormal];
        
        
        
    }
    return self;
}


- (void)boyBtnAction:(UIButton *)btn{
    btn.selected = YES;
    self.girlBtn.selected = NO;
    if (self.clickBoy) {
        self.clickBoy();
    }
    
    
}

- (void)girlBtnAction:(UIButton *)btn{
    btn.selected = YES;
    self.boyBtn.selected = NO;
    if (self.clickgirl) {
        self.clickgirl();
    }
    
    
}

- (void)sureBtnAction{
    
    if (self.clicksure) {
        self.clicksure();
    }
    
}

- (UIButton *)boyBtn{
    
    if (!_boyBtn) {
        _boyBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultLineColor nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"" selectImageName:@"" target:self action:@selector(boyBtnAction:)];
        [_boyBtn setBackgroundImage:GetImage(@"genderboynoaml") forState:UIControlStateNormal];
        [_boyBtn setBackgroundImage:GetImage(@"genderboyselect") forState:UIControlStateSelected];

    }
    
    return _boyBtn;
    
}
- (UIButton *)girlBtn{
    
    if (!_girlBtn) {
        _girlBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultLineColor nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"" selectImageName:@"" target:self action:@selector(girlBtnAction:)];
        [_girlBtn setBackgroundImage:GetImage(@"gendergirlnomal") forState:UIControlStateNormal];
        [_girlBtn setBackgroundImage:GetImage(@"gendergirlselect") forState:UIControlStateSelected];
    }
    
    return _girlBtn;
    
}


- (UIButton *)sureBtn{
    
    if (!_sureBtn) {
        _sureBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultLineColor nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:nil selectImageName:nil target:self action:@selector(sureBtnAction)];
    }
    
    return _sureBtn;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
