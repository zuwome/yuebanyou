//
//  XJHomeTitleSelectView.m
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJHomeTitleSelectView.h"

@interface XJHomeTitleSelectView ()

@property(nonatomic,strong) UIButton *recommondBtn;
@property(nonatomic,strong) UIButton *nearBtn;
@property(nonatomic,strong) UIView *redLine;


@end

@implementation XJHomeTitleSelectView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.recommondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_equalTo(45);
        }];
        
        
        [self.nearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.mas_equalTo(45);
        }];
        
        [self.redLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.recommondBtn);
            make.bottom.equalTo(self.recommondBtn).offset(-3);
            make.height.mas_equalTo(5);
            make.width.mas_equalTo(40);
        }];
    }
    return self;
}

- (CGSize)intrinsicContentSize{
    
    return CGSizeMake(150, 26);
}


- (void)setBtnIndex:(NSInteger)index{
    
    if (index == 0) {
        self.recommondBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:0.3];
        self.nearBtn.titleLabel.font = defaultFont(16);
        [UIView animateWithDuration:0.3f animations:^{
            
            [self.redLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.recommondBtn);
                make.bottom.equalTo(self.recommondBtn).offset(-3);
                make.height.mas_equalTo(5);
                make.width.mas_equalTo(40);
            }];
            [self layoutIfNeeded];
        }];
        
    }else{
        self.recommondBtn.titleLabel.font = defaultFont(16);
        self.nearBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:0.3] ;
        [UIView animateWithDuration:0.3f animations:^{
            
            [self.redLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.nearBtn);
                make.bottom.equalTo(self.nearBtn).offset(-3);
                make.height.mas_equalTo(5);
                make.width.mas_equalTo(40);
            }];
            [self layoutIfNeeded];
        }];
        
    }
    
    
}


- (void)reBtnAction:(UIButton *)btn{
    
    self.recommondBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:0.3];
    self.nearBtn.titleLabel.font = defaultFont(16);
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.redLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.bottom.equalTo(btn).offset(-3);
            make.height.mas_equalTo(5);
            make.width.mas_equalTo(40);
            
        }];
        [self layoutIfNeeded];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRecommond)]) {
        [self.delegate clickRecommond];
    }
    
}
- (void)nearBtnAction:(UIButton *)btn{
    
    self.recommondBtn.titleLabel.font = defaultFont(16);
    self.nearBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:0.3] ;
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.redLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.bottom.equalTo(btn).offset(-3);
            make.height.mas_equalTo(5);
            make.width.mas_equalTo(40);
        }];
        [self layoutIfNeeded];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickNear)]) {
        [self.delegate clickNear];
    }
}

- (UIButton *)recommondBtn{
    
    if (!_recommondBtn) {
        _recommondBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultWhite nomalTitle:@"推荐" titleColor:defaultBlack titleFont:[UIFont systemFontOfSize:18 weight:0.3] nomalImageName:nil selectImageName:nil target:self action:@selector(reBtnAction:)];
    }
    return _recommondBtn;
    
    
}
- (UIButton *)nearBtn{
    
    if (!_nearBtn) {
        _nearBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultWhite nomalTitle:@"附近" titleColor:defaultBlack titleFont:defaultFont(16) nomalImageName:nil selectImageName:nil target:self action:@selector(nearBtnAction:)];

    }
    return _nearBtn;
    
    
}
- (UIView *)redLine{
    
    if (!_redLine) {
        
        _redLine = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:[UIColor redColor]];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 67, 32)];
        [_redLine.layer addSublayer:gradientLayer];
        _redLine.layer.cornerRadius = 2.5;
        _redLine.layer.masksToBounds = YES;
       
        
    }
    return _redLine;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
