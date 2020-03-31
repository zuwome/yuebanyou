//
//  XJReportTextTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJReportTextTbCell.h"

@interface XJReportTextTbCell()

@property(nonatomic,strong) UILabel *contenLb;
@property(nonatomic,strong) UIButton *selectBtn;


@end

@implementation XJReportTextTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contenLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.height.mas_equalTo(15);
        }];
        
    }
    return self;
    
}
- (void)setUpContent:(NSString *)title isSelect:(BOOL)select{
    
    self.contenLb.text = title;
    self.selectBtn.selected = select;
    
}

- (void)selectBtnAction:(UIButton *)btn{
    
    
    
    
    
}


- (UILabel *)contenLb{
    
    if (!_contenLb) {
        _contenLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _contenLb;
    
}
- (UIButton *)selectBtn{
  
    if (!_selectBtn) {
        _selectBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"btnnomal" selectImageName:@"btnSelected" target:self action:@selector(selectBtnAction:)];
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
