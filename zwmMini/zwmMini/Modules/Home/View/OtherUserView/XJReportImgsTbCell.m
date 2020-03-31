//
//  XJReportImgsTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJReportImgsTbCell.h"

@interface XJReportImgsTbCell()

@property(nonatomic,strong)UIButton *addIVBtn;

@end

@implementation XJReportImgsTbCell





- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = defaultWhite;
//        UILabel *titleiv = [XJUIFactory creatUIImageViewWithFrame:CGRectMake(15, 15, 14, 14) addToView:self.contentView imageUrl:nil placehoderImage:@""];
        
        UILabel *titileLb = [XJUIFactory creatUILabelWithFrame:CGRectMake(15, 15, 70, 20) addToView:self.contentView textColor:defaultBlack text:@"图片证据" font:defaultFont(15) textInCenter:NO];
        [self.addIVBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titileLb);
            make.top.equalTo(titileLb.mas_bottom).offset(16);
            make.width.height.mas_equalTo(107);
        }];
        
    }
    return self;
    
    
}

- (void)addImageAction:(UIButton *)btn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addImage:)]) {
        [self.delegate addImage:btn];
    }
    
}


- (UIButton *)addIVBtn{
    
    if (!_addIVBtn) {
        _addIVBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"addphotoimg" selectImageName:nil target:self action:@selector(addImageAction:)];
        [_addIVBtn setBackgroundImage:GetImage(@"xukuang") forState:UIControlStateNormal];
    }
    return _addIVBtn;
    
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
