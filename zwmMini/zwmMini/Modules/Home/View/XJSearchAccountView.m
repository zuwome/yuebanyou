//
//  XJSearchAccountView.m
//  zwmMini
//
//  Created by Batata on 2018/11/22.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSearchAccountView.h"

@interface XJSearchAccountView ()

@property(nonatomic,strong) UITextField *searchTf;

@end

@implementation XJSearchAccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = defaultWhite;
        UIImageView *bigIV = [UIImageView new];
        [self addSubview:bigIV];
        [bigIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(17);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(22);
        }];
        bigIV.image = GetImage(@"sousuo2");
        [self.searchTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bigIV.mas_right).offset(12);
            make.centerY.equalTo(bigIV);
            make.right.equalTo(self).offset(17);
        }];
        
//        UIView *line = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultLineColor];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.height.mas_equalTo(1);
//        }];
        
        
        
    }
    return self;
}


- (void)searchTextChange:(UITextField *)tf{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(seachText:)]) {
        
        [self.delegate seachText:tf.text];
    }
    
}


- (UITextField *)searchTf{
    if (!_searchTf) {
        
        _searchTf = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入用户名或账号" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        [_searchTf addTarget:self action:@selector(searchTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTf;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
