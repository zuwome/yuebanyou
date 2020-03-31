//
//  XJMsgInputTophintView.m
//  zwmMini
//
//  Created by Batata on 2018/12/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMsgInputTophintView.h"

@interface XJMsgInputTophintView()

@property(nonatomic,strong) UILabel *hintLb;
@property(nonatomic,strong) UIImageView *hintIV;

@end

@implementation XJMsgInputTophintView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGB(255, 233, 237);
        [self.hintLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        [self.hintIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.hintLb.mas_left).offset(-3);
            make.centerY.equalTo(self.hintLb);
            make.width.height.mas_equalTo(12);
        }];
        
    }
    return self;
    
    
}
- (void)setHintText:(NSString *)hintText{
    _hintText = hintText;
    self.hintLb.text = hintText;
    
}

- (UILabel *)hintLb{

    if (!_hintLb) {
        
        _hintLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"" font:defaultFont(12) textInCenter:YES];
    }
    return _hintLb;
}
- (UIImageView *)hintIV{
    
    if (!_hintIV) {
        
        _hintIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self imageUrl:nil placehoderImage:@"shouyi1yuan"];
    }
    return _hintIV;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
