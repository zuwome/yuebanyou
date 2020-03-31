//
//  XJMyHeadView.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyHeadView.h"

@interface XJMyHeadView()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *nickNameLb;
@property(nonatomic,strong) UILabel *accountLb;
@property(nonatomic,strong) UILabel *myinterductionLb;
@property(nonatomic,strong) UIButton *editBtn;






@end


@implementation XJMyHeadView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.width.height.mas_lessThanOrEqualTo(110);
        }];
        self.headIV.layer.cornerRadius = 55;
        self.headIV.layer.masksToBounds = YES;
        
        [self.nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIV.mas_right).offset(12);
            make.width.mas_equalTo(160);
            make.top.equalTo(self.headIV).offset(17);
        }];
        
        [self.accountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickNameLb);
            make.centerY.equalTo(self.headIV);
        }];
        
        [self.myinterductionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickNameLb);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self.accountLb.mas_bottom).offset(10);
        }];
        
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self.nickNameLb);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(24);
        }];
        self.editBtn.layer.cornerRadius = 12;
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.borderWidth = 1;
        self.editBtn.layer.borderColor = defaultGray.CGColor;
        
    }
    return self;
}

- (void)setUpHeadViewInfo:(XJUserModel *)model{
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.nickNameLb.text = model.nickname;
    self.accountLb.text = [NSString stringWithFormat:@"账号:%@",model.ZWMId];
    self.myinterductionLb.text = model.bio;
    
}

- (void)headIVAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHeadIV)]) {
        [self.delegate clickHeadIV];
    }
}



- (void)editBtnAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(editPersonalData)]) {
        [self.delegate editPersonalData];
    }
    
}


- (UIImageView *)headIV{
    
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self imageUrl:nil placehoderImage:@""];
        _headIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headIVAction)];
        [_headIV addGestureRecognizer:headTap];
    }
    return _headIV;
}

- (UILabel *)nickNameLb{
    
    if (!_nickNameLb) {
        _nickNameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _nickNameLb;
}

- (UILabel *)accountLb{
    
    if (!_accountLb) {
        _accountLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"" font:defaultFont(13) textInCenter:NO];
    }
    return _accountLb;
}
- (UILabel *)myinterductionLb{
    
    if (!_myinterductionLb) {
        _myinterductionLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultGray text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _myinterductionLb;
}

- (UIButton *)editBtn{
    
    if (!_editBtn) {
        _editBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultWhite nomalTitle:@"编辑" titleColor:defaultGray titleFont:defaultFont(12) nomalImageName:@"" selectImageName:nil target:self action:@selector(editBtnAction)];
        
    }
    return _editBtn;
    
}


@end
