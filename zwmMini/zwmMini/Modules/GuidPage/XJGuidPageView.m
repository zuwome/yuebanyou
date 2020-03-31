//
//  XJGuidPageView.m
//  zwmMini
//
//  Created by Batata on 2018/12/24.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJGuidPageView.h"


#define tempWidth(w) (kScreenWidth/375.f)*w

@interface XJGuidPageView()

@property(nonatomic,strong) UIImageView *bgIV;
@property(nonatomic,strong) UIImageView *centerIV;
@property(nonatomic,strong) UILabel *titlelb;
@property(nonatomic,strong) UILabel *contetlb;
@property(nonatomic,strong) UIImageView *bottomIV;


@end

@implementation XJGuidPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self creatViews];
    }
    return self;
}

- (void)creatViews{
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.bottomIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgIV);
        make.bottom.equalTo(self.bgIV).offset(-tempWidth(42));
        make.width.mas_equalTo(tempWidth(60));
        make.height.mas_equalTo(tempWidth(8));
    }];
    
    [self.centerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgIV).offset(tempWidth(40));
        make.centerX.equalTo(self.bgIV);
        make.width.mas_equalTo(tempWidth(230));
        make.height.mas_equalTo(tempWidth(410));
    }];
    
    [self.contetlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgIV);
        make.bottom.equalTo(self.centerIV.mas_top).offset(-tempWidth(12));
        make.width.mas_equalTo(tempWidth(290));
    }];
    
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIV).offset(43);
        make.bottom.equalTo(self.contetlb.mas_top).offset(-tempWidth(15));
    }];
    
   
    
}


- (void)setUpTitle:(NSString *)title content:(NSString *)content ceterIV:(NSString *)centimag bottomIV:(NSString *)boottomimg{
    
    self.titlelb.text = title;
    self.contetlb.text = content;
    self.centerIV.image = GetImage(centimag);
    self.bottomIV.image = GetImage(boottomimg);
    
}


#pragma mark lazy


- (UIImageView *)bgIV{
    
    if (!_bgIV) {
        _bgIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self imageUrl:nil placehoderImage:@"guidbgimg1"];
    }
    return _bgIV;
}
- (UIImageView *)centerIV{
    
    if (!_centerIV) {
        _centerIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self imageUrl:nil placehoderImage:@""];
    }
    return _centerIV;
}

- (UILabel *)titlelb{
    if (!_titlelb) {
        
        _titlelb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgIV textColor:defaultBlack text:@"" font:[UIFont boldSystemFontOfSize:26] textInCenter:NO];
    }
    return _titlelb;
}
- (UILabel *)contetlb{
    if (!_contetlb) {
        
        _contetlb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgIV textColor:RGB(102, 102, 102) text:@"" font:defaultFont(16) textInCenter:YES];
        _contetlb.numberOfLines = 0;
    }
    return _contetlb;
}
- (UIImageView *)bottomIV{
    
    if (!_bottomIV) {
        _bottomIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgIV imageUrl:nil placehoderImage:@""];
    }
    return _bottomIV;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
