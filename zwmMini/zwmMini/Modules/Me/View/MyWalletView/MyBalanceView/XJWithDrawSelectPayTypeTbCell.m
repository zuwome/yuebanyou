//
//  XJWithDrawSelectPayTypeTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJWithDrawSelectPayTypeTbCell.h"


@interface XJWithDrawSelectPayTypeTbCell()

@property(nonatomic,strong) UIImageView *IV;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UIButton *selectBtn;

@end

@implementation XJWithDrawSelectPayTypeTbCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.IV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(30);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(18);
        }];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.IV.mas_right).offset(12);

        }];
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-35);
            make.width.height.mas_equalTo(18);
        }];
    }
    
    return self;
    
}
- (void)setUpImage:(NSString *)imgName Title:(NSString *)title isSelect:(BOOL)select{
    self.IV.image = GetImage(imgName);
    self.titleLb.text = title;
    self.selectBtn.selected = select;
}

- (void)selectAction:(UIButton *)btn{
    
//    btn.selected = !btn.selected;
    
}




#pragma mark lazy
- (UIImageView *)IV{
    if (!_IV) {
        
        _IV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:nil placehoderImage:@"wxpayimg"];
    }
    return _IV;
    
}
- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _titleLb;
    
}
- (UIButton *)selectBtn{
    if (!_selectBtn) {
        
        _selectBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"btn_report_n" selectImageName:@"reddago" target:self action:@selector(selectAction:)];
    }
    return _selectBtn;
    
    
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
