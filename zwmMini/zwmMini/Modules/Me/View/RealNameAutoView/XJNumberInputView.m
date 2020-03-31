//
//  XJNumberInputView.m
//  zwmMini
//
//  Created by Batata on 2018/12/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJNumberInputView.h"

@interface XJNumberInputView()

@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UITextField *contentTf;


@end

@implementation XJNumberInputView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = defaultWhite;
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        self.contentTf.frame = CGRectMake(70, 0, kScreenWidth-70, frame.size.height);
//        [self.contentTf mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.nameLb);
//            make.left.equalTo(self.nameLb.mas_right).offset(30);
//            make.right.equalTo(self).offset(-30);
//
//        }];
        
    }
    return self;
}

- (void)setNameStr:(NSString *)nameStr{
    self.nameLb.text = nameStr;
}
- (void)setPlaceholderStr:(NSString *)placeholderStr{
    self.contentTf.placeholder = placeholderStr;
}
- (void)setInputnumStr:(NSString *)inputnumStr{
    self.contentTf.text = inputnumStr;
}
- (void)setIsCanEdit:(BOOL)isCanEdit{
    
    self.contentTf.enabled = isCanEdit;
    
}


- (void)contentTextChange:(UITextField *)tf{
    
    if (self.block) {
        self.block(tf.text);
    }
    
}





- (UILabel *)nameLb{
    if (!_nameLb) {
        
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:self.nameStr font:defaultFont(15) textInCenter:NO];
        
    }
    return _nameLb;
    
}

- (UITextField *)contentTf{
    if (!_contentTf) {
        _contentTf = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self textColor:defaultBlack textFont:defaultFont(15) placeholderText:self.placeholderStr placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(15) delegate:self];
        [_contentTf addTarget:self action:@selector(contentTextChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _contentTf;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
