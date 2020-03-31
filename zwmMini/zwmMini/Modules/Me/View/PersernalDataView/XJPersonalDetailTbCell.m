//
//  XJPersonalDetailTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/3.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJPersonalDetailTbCell.h"

@interface XJPersonalDetailTbCell()

//先这样复制粘贴了改天再回头改
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *wxtitleLb;
@property(nonatomic,strong) UILabel *biotitleLb;
@property(nonatomic,strong) UILabel *acctitleLb;
@property(nonatomic,strong) UILabel *agetitleLb;
@property(nonatomic,strong) UILabel *heititleLb;
@property(nonatomic,strong) UILabel *weititleLb;
@property(nonatomic,strong) UILabel *worktitleLb;
@property(nonatomic,strong) UILabel *contitleLb;

@property(nonatomic,strong) UILabel *wxLb;
@property(nonatomic,strong) UILabel *bioLb;
@property(nonatomic,strong) UILabel *accLb;
@property(nonatomic,strong) UILabel *ageLb;
@property(nonatomic,strong) UILabel *heightLb;
@property(nonatomic,strong) UILabel *weightLb;
@property(nonatomic,strong) UILabel *worksLb;
@property(nonatomic,strong) UILabel *conLb;

@property(nonatomic,strong) UIButton *lookWxBtn;



@end

@implementation XJPersonalDetailTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        
        [self.bgView addSubview:self.titleLb];
        [self.bgView addSubview:self.wxtitleLb];
        [self.bgView addSubview:self.wxLb];
        [self.bgView addSubview:self.lookWxBtn];
        [self.bgView addSubview:self.biotitleLb];
        [self.bgView addSubview:self.bioLb];
        [self.bgView addSubview:self.acctitleLb];
        [self.bgView addSubview:self.accLb];
        [self.bgView addSubview:self.agetitleLb];
        [self.bgView addSubview:self.ageLb];
        [self.bgView addSubview:self.heititleLb];
        [self.bgView addSubview:self.heightLb];
        [self.bgView addSubview:self.weititleLb];
        [self.bgView addSubview:self.weightLb];
        [self.bgView addSubview:self.worktitleLb];
        [self.bgView addSubview:self.worksLb];
        [self.bgView addSubview:self.contitleLb];
        [self.bgView addSubview:self.conLb];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(15);
            make.top.equalTo(self.bgView).offset(15);
        }];
        
        [self.wxtitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(self.titleLb.mas_bottom).offset(18);
        }];
        [self.wxLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wxtitleLb);
            make.left.equalTo(self.wxtitleLb.mas_right).offset(16);
        }];
        
        [self.lookWxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.wxtitleLb);
            make.left.equalTo(self.wxtitleLb.mas_right).offset(16);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(32);
        }];
    }
    return self;
}

- (void)setUpPersonalData:(XJUserModel *)model isOneself:(BOOL)oneslef{
    UILabel *lastLabel = _wxtitleLb;
    
    // 微信
    self.wxLb.text = model.have_wechat_no ? model.wechat.no:@"";
    lastLabel = self.wxLb;
    
    // 个人介绍
    if (!NULLString(model.bio)) {
        [self.biotitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(lastLabel.mas_bottom).offset(18);
        }];
        
        [self.bioLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.biotitleLb.mas_bottom).offset(18);
            make.left.equalTo(self.titleLb);
            make.right.equalTo(self.bgView).offset(-15);
        }];
        self.bioLb.text = NULLString(model.bio)? @"暂无介绍":model.bio;
        lastLabel = self.bioLb;
    }
    
    // 账号
    if (!NULLString(model.ZWMId)) {
        [self.acctitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(lastLabel.mas_bottom).offset(18);
        }];
        [self.accLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.acctitleLb);
            make.left.equalTo(self.acctitleLb.mas_right).offset(16);
        }];
        self.accLb.text = model.ZWMId;
        lastLabel = self.acctitleLb;
    }
    
    // age
    if (model.age > 0) {
        [self.agetitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(lastLabel.mas_bottom).offset(18);
        }];
        [self.ageLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.agetitleLb);
            make.left.equalTo(self.agetitleLb.mas_right).offset(16);
        }];
        self.ageLb.text = [NSString stringWithFormat:@"%ld",model.age];
        lastLabel = self.agetitleLb;
    }
    
    // height
    if (!NULLString(model.heightIn)) {
        [self.heititleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(lastLabel.mas_bottom).offset(18);
        }];
        [self.heightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.heititleLb);
            make.left.equalTo(self.heititleLb.mas_right).offset(16);
        }];
        self.heightLb.text = NULLString(model.heightIn)?@"":model.heightIn;
        lastLabel = self.heititleLb;
    }
    
    // width
    if (!NULLString(model.weightIn)) {
        [self.weititleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(lastLabel.mas_bottom).offset(18);
        }];
        [self.weightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weititleLb);
            make.left.equalTo(self.weititleLb.mas_right).offset(16);
        }];
        self.weightLb.text = NULLString(model.weightIn)? @"":model.weightIn;
        lastLabel = self.weititleLb;
    }
    
    // jobs
    if (model.works_new.count > 0) {
        [self.worktitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(lastLabel.mas_bottom).offset(18);
        }];
        [self.worksLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.worktitleLb);
            make.left.equalTo(self.worktitleLb.mas_right).offset(16);
        }];

        NSMutableString *worstr = @"".mutableCopy;
        for (XJInterstsModel *work in model.works_new) {
            [worstr appendFormat:@"、%@",work.content];
        }
        if (!NULLString(worstr)) {
            [worstr deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        self.worksLb.text = worstr;

        lastLabel = self.worktitleLb;
    }
    
    // constellation
    if (!NULLString(model.constellation)) {
        [self.contitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.top.equalTo(lastLabel.mas_bottom).offset(18);
        }];
        [self.conLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contitleLb);
            make.left.equalTo(self.contitleLb.mas_right).offset(16);
        }];
        self.conLb.text = NULLString(model.constellation)? @"":model.constellation;
        lastLabel = self.contitleLb;
    }
    
    [lastLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(-16);
    }];
    
//
//    self.bioLb.text = NULLString(model.bio)? @"暂无介绍":model.bio;
//    self.accLb.text = model.ZWMId;
//    self.ageLb.text = [NSString stringWithFormat:@"%ld",model.age];
//    self.heightLb.text = NULLString(model.heightIn)?@"":model.heightIn;
//    self.weightLb.text = NULLString(model.weightIn)? @"":model.weightIn;
//    NSMutableString *worstr = @"".mutableCopy;
//    for (XJInterstsModel *work in model.works_new) {
//        [worstr appendFormat:@"、%@",work.content];
//    }
//    if (!NULLString(worstr)) {
//        [worstr deleteCharactersInRange:NSMakeRange(0, 1)];
//    }
//    self.worksLb.text = worstr;
//    self.conLb.text = NULLString(model.constellation)? @"":model.constellation;
    
    //个人详情
    if (oneslef) {
        self.wxLb.hidden = NO;
        self.lookWxBtn.hidden = YES;

    //他人详情
    }else{
        //已查看过
        if (model.can_see_wechat_no) {
            self.wxLb.hidden = NO;
            self.lookWxBtn.hidden = YES;
        }else{
            self.wxLb.hidden = YES;
            self.lookWxBtn.hidden = NO;
        }

    }

}


- (void)lookWxBtnAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLookoverWxBtn)]) {
        
        [self.delegate clickLookoverWxBtn];
    }
}


-(UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
        _bgView.layer.shadowOffset = CGSizeMake(1,1);
        _bgView.layer.shadowOpacity = 0.3;
        _bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
    
}
- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:[UIColor blackColor] text:@"个人详情" font:defaultFont(19) textInCenter:NO];
    }
    return _titleLb;
    
}
- (UILabel *)wxtitleLb{
    
    if (!_wxtitleLb) {
        _wxtitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultGray text:@"微信号" font:defaultFont(15) textInCenter:NO];
    }
    return _wxtitleLb;
    
}
- (UILabel *)biotitleLb{
    
    if (!_biotitleLb) {
        _biotitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultGray text:@"自我介绍" font:defaultFont(15) textInCenter:NO];
    }
    return _biotitleLb;
    
}
- (UILabel *)acctitleLb{
    
    if (!_acctitleLb) {
        _acctitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultGray text:@"账号" font:defaultFont(15) textInCenter:NO];
    }
    return _acctitleLb;
    
}

- (UILabel *)agetitleLb {
    if (!_agetitleLb) {
        _agetitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil textColor:defaultGray text:@"年龄" font:defaultFont(15) textInCenter:NO];
    }
    return _agetitleLb;
}

- (UILabel *)heititleLb{
    if (!_heititleLb) {
        _heititleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultGray text:@"身高" font:defaultFont(15) textInCenter:NO];
    }
    return _heititleLb;
}

- (UILabel *)weititleLb{
    if (!_weititleLb) {
        _weititleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultGray text:@"体重" font:defaultFont(15) textInCenter:NO];
    }
    return _weititleLb;
}

- (UILabel *)worktitleLb {
    if (!_worktitleLb) {
        _worktitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultGray text:@"职业" font:defaultFont(15) textInCenter:NO];
    }
    return _worktitleLb;
}

- (UILabel *)contitleLb {
    if (!_contitleLb) {
        _contitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultGray text:@"星座" font:defaultFont(15) textInCenter:NO];
    }
    return _contitleLb;
}

- (UILabel *)wxLb {
    if (!_wxLb) {
        _wxLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:[UIColor redColor] text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _wxLb;
}

- (UILabel *)bioLb {
    if (!_bioLb) {
        _bioLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
        _bioLb.numberOfLines = 0;
    }
    return _bioLb;
}

- (UILabel *)accLb {
    if (!_accLb) {
        _accLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _accLb;
}

- (UILabel *)ageLb {
    if (!_ageLb) {
        _ageLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _ageLb;
}
- (UILabel *)heightLb {
    if (!_heightLb) {
        _heightLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _heightLb;
}

- (UILabel *)weightLb {
    if (!_weightLb) {
        _weightLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _weightLb;
}

- (UILabel *)worksLb {
    if (!_worksLb) {
        _worksLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _worksLb;
}

- (UILabel *)conLb {
    if (!_conLb) {
        _conLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _conLb;
}

- (UIButton *)lookWxBtn {
    if (!_lookWxBtn) {
        _lookWxBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:nil backColor:defaultWhite nomalTitle:@"查看微信" titleColor:RGB(254, 83, 108) titleFont:defaultFont(15) nomalImageName:nil selectImageName:nil target:self action:@selector(lookWxBtnAction)];
        _lookWxBtn.layer.borderWidth = 1;
        _lookWxBtn.layer.borderColor = RGB(254, 83, 108).CGColor;
        _lookWxBtn.layer.cornerRadius = 16;
        _lookWxBtn.layer.masksToBounds = YES;
    }
    return _lookWxBtn;
}

@end
