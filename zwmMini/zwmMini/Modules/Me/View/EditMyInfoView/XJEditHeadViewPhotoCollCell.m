//
//  XJEditHeadViewPhotoCollCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditHeadViewPhotoCollCell.h"

@interface XJEditHeadViewPhotoCollCell()

@property(nonatomic,strong) UIImageView *headIV;



@end

@implementation XJEditHeadViewPhotoCollCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = defaultLineColor;
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _coverBgView = [[UIView alloc] init];
        _coverBgView.backgroundColor = HEXACOLOR(0x000000, 0.7);
        [self.contentView addSubview:_coverBgView];
        
        [_coverBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        self.errorView.hidden = YES;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
    
}
- (void)tapSelf{
    
    if (self.tapBlock) {
        self.tapBlock();
    }
    
}


- (void)setImgWithPhptpModel:(XJPhoto *)model{
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    
}

- (UIImageView *)headIV{
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
    }
    return _headIV;
}

- (UIView *)errorView {
    if (!_errorView) {
        _errorView = [[UIView alloc] init];
        [self.contentView addSubview:_errorView];
        
        [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        _errorImgView = [[UIImageView alloc] init];
        _errorImgView.image = [UIImage imageNamed:@"gantanhao"];
        [_errorView addSubview:_errorImgView];
        
        [_errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_errorView.mas_centerX);
            make.top.mas_equalTo(_errorView.mas_top);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.textColor = HEXCOLOR(0xFD5F66);
        _errorLabel.font = [UIFont systemFontOfSize:15];
        _errorLabel.text = @"头像位置只能放置本人正脸五官清晰的照片哦";
        _errorLabel.numberOfLines = 0;
        [_errorView addSubview:_errorLabel];
        
        [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_errorView);
            make.top.mas_equalTo(_errorImgView.mas_bottom).offset(10);
        }];
    }
    return _errorView;
}


@end
