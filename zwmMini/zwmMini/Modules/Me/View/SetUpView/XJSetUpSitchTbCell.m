//
//  XJSetUpSitchTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/3.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSetUpSitchTbCell.h"

@interface XJSetUpSitchTbCell()

@property(nonatomic,strong) UILabel *titleLb;
@property (nonatomic, strong) UISwitch *setSwitch;


@end

@implementation XJSetUpSitchTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        [self.setSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
    
}

- (void)setUpTitle:(NSString *)title isOnSwitch:(BOOL)isOn{
    
    
    self.titleLb.text = title;
    [self.setSwitch setOn:isOn];
    self.setSwitch.enabled = !_isNoti;
    
}
- (void)valueChanged:(UISwitch *)sit{
    
    
    if (self.block) {
        self.block(sit);
    }
    
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
        
    }
    return _titleLb;
    
    
}
- (UISwitch *)setSwitch{
    
    if (!_setSwitch) {
        _setSwitch = [[UISwitch alloc] init];
        _setSwitch.onTintColor = defaultRedColor;
        [_setSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
        [self.contentView addSubview:_setSwitch];
    }
    return _setSwitch;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
