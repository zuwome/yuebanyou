//
//  XJEditInfoTableViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditInfoTableViewCell.h"

@interface XJEditInfoTableViewCell ()

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *detailLb;



@end

@implementation XJEditInfoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *arrowIv = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:nil placehoderImage:@"rightarrwoimg"];
        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
        }];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        [self.detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(arrowIv).offset(-20);
            make.left.equalTo(self.titleLb.mas_right).offset(20);
        }];
        
        
        
        
    }
    return self;
    
}

- (void)setTitles:(NSString *)title andDetail:(NSString *)detail{
    self.titleLb.text = title;
    self.detailLb.text = detail;
}

- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(102, 102, 102) text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _titleLb;
}
- (UILabel *)detailLb{
    
    if (!_detailLb) {
        _detailLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:NO];
        _detailLb.textAlignment = NSTextAlignmentRight;
    }
    return _detailLb;
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
