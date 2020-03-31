//
//  XJBadEvualuateCoCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/10.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBadEvualuateCoCell.h"

@interface XJBadEvualuateCoCell()

@property(nonatomic,strong) UILabel *contentLb;

@end

@implementation XJBadEvualuateCoCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-32);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(38);
        }];
        
        
    }
    return self;
    
}
- (void)setUpContent:(NSString *)content isSelect:(BOOL)select IndexPath:(NSIndexPath *)indexpath{
    
    
    if (indexpath.item %2 == 0) {
        [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-32);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(38);
        }];
    }else{
        
        [self.contentLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(32);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(38);
        }];
    }
   
    
    self.contentLb.text = content;
    if (select) {
        self.contentLb.layer.borderColor = defaultRedColor.CGColor;
        self.contentLb.layer.borderWidth = 1;
        self.contentLb.backgroundColor = defaultRedColor;
        self.contentLb.textColor = defaultWhite;
    }else{
        
        self.contentLb.layer.borderColor = RGB(228, 228, 228).CGColor;
        self.contentLb.layer.borderWidth = 1;
        self.contentLb.backgroundColor = defaultWhite;
        self.contentLb.textColor = defaultBlack;
    }
    
    
    
}



- (UILabel *)contentLb{
    
    if (!_contentLb) {
        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(13) textInCenter:YES];
        _contentLb.layer.cornerRadius = 3;
        
    }
    return _contentLb;
    
}

@end
