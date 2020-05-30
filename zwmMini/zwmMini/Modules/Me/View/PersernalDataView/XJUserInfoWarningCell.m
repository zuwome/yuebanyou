//
//  XJUserInfoWarningCell.m
//  zwmMini
//
//  Created by qiming xiao on 2020/5/29.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJUserInfoWarningCell.h"

@interface XJUserInfoWarningCell ()

@property (nonatomic, strong) UILabel *warningLabel;

@end

@implementation XJUserInfoWarningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBA(254, 83, 108, 0.34);
    
    [self addSubview:self.warningLabel];
    [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@40);
    }];
}

#pragma mark - getters and setters
- (UILabel *)warningLabel {
    if (!_warningLabel) {
        _warningLabel = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:nil  textColor:RGB(122, 108, 107) text:@"平台严禁任何违规违法行为，发布低俗不良信息将被封禁处理" font:defaultFont(14) textInCenter:NO];
        _warningLabel.numberOfLines = 2;
    }
    return _warningLabel;
}

@end
