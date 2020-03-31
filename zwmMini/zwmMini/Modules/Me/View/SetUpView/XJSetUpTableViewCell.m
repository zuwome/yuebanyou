//
//  XJSetUpTableViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSetUpTableViewCell.h"

@interface XJSetUpTableViewCell()

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *sizeLb;
@end

@implementation XJSetUpTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        [self.sizeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.titleLb);
        }];
        
    }
    return self;
    
    
}



- (void)setUpTitle:(NSString *)title andCach:(CGFloat )cahgfloat withIndexPath:(NSIndexPath *)indexPath{
    
    
    self.titleLb.text = title;
    self.sizeLb.text = [NSString stringWithFormat:@"%.2fMB",cahgfloat];
    self.sizeLb.textColor = RGB(102, 102, 102);
    if (indexPath.section == 3) {
        self.sizeLb.hidden = NO;
    }else{
        
        self.sizeLb.hidden = YES;
    }
    
}



- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    
    return _titleLb;
    
}
- (UILabel *)sizeLb{
    
    if (!_sizeLb) {
        _sizeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    
    return _sizeLb;
    
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
