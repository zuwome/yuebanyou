//
//  ZZUpdateAlertView.m
//  zuwome
//
//  Created by angBiu on 2017/6/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUpdateAlertView.h"

@implementation ZZUpdateAlertView

- (instancetype)initWithFrame:(CGRect)frame upgradeTips:(NSDictionary *)tips {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.5);
        [self addSubview:coverView];
        
        CGFloat scale = kScreenWidth/375.0;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 6;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(302*scale);
        }];
        
        UIImageView *topImgView = [[UIImageView alloc] init];
        topImgView.image = [UIImage imageNamed:@"icon_update_top"];
        [bgView addSubview:topImgView];
        
        [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(bgView);
            make.height.mas_equalTo(190.5*scale);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HEXCOLOR(0x000000);
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.numberOfLines = 0;
        [bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(15);
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.bottom.mas_equalTo(topImgView.mas_bottom).offset(-8);
        }];
        
        if (NULLString(tips[@"title"])) {
            titleLabel.text = [NSString stringWithFormat:@"请升级到最新版本"];
        }
        else {
            titleLabel.text = tips[@"title"];
        }
        
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXCOLOR(0x9B9B9B);
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        [bgView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(titleLabel);
            make.top.mas_equalTo(topImgView.mas_bottom).offset(5);
        }];
        
        NSMutableString *strM = @"".mutableCopy;
        NSArray<NSString *> *infos = tips[@"arr"];
        if ([infos isKindOfClass:[NSArray class]] && infos.count != 0) {
            [infos enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [strM appendString:obj];
                if (idx != infos.count - 1) {
                    [strM appendString:@"\n"];
                }
            }];
        }
        contentLabel.text = strM.copy;
        
        UIButton *updateBtn = [[UIButton alloc] init];
        updateBtn.backgroundColor = kYellowColor;
        updateBtn.layer.cornerRadius = 22;
        [updateBtn setTitle:@"升级" forState:UIControlStateNormal];
        [updateBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        updateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [updateBtn addTarget:self action:@selector(updateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:updateBtn];
        
        [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(140, 44));
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-20);
        }];
        
        updateBtn.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        updateBtn.layer.shadowOffset = CGSizeMake(0, 1);
        updateBtn.layer.shadowOpacity = 0.9;
        updateBtn.layer.shadowRadius = 1;
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UIImageView *cancelImgView = [[UIImageView alloc] init];
        cancelImgView.image = [UIImage imageNamed:@"icon_errorinfo_cancel"];
        cancelImgView.userInteractionEnabled = NO;
        [bgView addSubview:cancelImgView];
        
        [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_top).offset(15);
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.5);
        [self addSubview:coverView];
        
        CGFloat scale = kScreenWidth/375.0;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 6;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(302*scale);
        }];
        
        UIImageView *topImgView = [[UIImageView alloc] init];
        topImgView.image = [UIImage imageNamed:@"icon_update_top"];
        [bgView addSubview:topImgView];
        
        [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(bgView);
            make.height.mas_equalTo(190.5*scale);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = HEXCOLOR(0x000000);
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.numberOfLines = 0;
        [bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left).offset(15);
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.bottom.mas_equalTo(topImgView.mas_bottom).offset(-8);
        }];
        
        if (NULLString(XJUserAboutManageer.sysCofigModel.version.title)) {
            titleLabel.text = [NSString stringWithFormat:@"请升级到最新版本"];
        }
        else {
            titleLabel.text = XJUserAboutManageer.sysCofigModel.version.title;
        }
//        if (XJUserAboutManageer.isLogin) {
//            titleLabel.text = [NSString stringWithFormat:@"亲爱的%@",XJUserAboutManageer.uModel.nickname];
//        }
//        else {
//            titleLabel.text = @"亲爱的";
//        }
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXCOLOR(0x9B9B9B);
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        [bgView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(titleLabel);
            make.top.mas_equalTo(topImgView.mas_bottom).offset(5);
        }];
        
        contentLabel.text = XJUserAboutManageer.sysCofigModel.version.version.des;
        
        UIButton *updateBtn = [[UIButton alloc] init];
        updateBtn.backgroundColor = kYellowColor;
        updateBtn.layer.cornerRadius = 22;
        [updateBtn setTitle:@"升级" forState:UIControlStateNormal];
        [updateBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        updateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [updateBtn addTarget:self action:@selector(updateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:updateBtn];
        
        [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(140, 44));
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-20);
        }];
        
        updateBtn.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        updateBtn.layer.shadowOffset = CGSizeMake(0, 1);
        updateBtn.layer.shadowOpacity = 0.9;
        updateBtn.layer.shadowRadius = 1;
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(bgView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UIImageView *cancelImgView = [[UIImageView alloc] init];
        cancelImgView.image = [UIImage imageNamed:@"icon_errorinfo_cancel"];
        cancelImgView.userInteractionEnabled = NO;
        [bgView addSubview:cancelImgView];
        
        [cancelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_top).offset(15);
            make.right.mas_equalTo(bgView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    
    return self;
}

- (void)updateBtnClick
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XJUserAboutManageer.sysCofigModel.version.version.link]];
    [self cancelBtnClick];
}

- (void)cancelBtnClick
{
    [self removeFromSuperview];
}



@end
