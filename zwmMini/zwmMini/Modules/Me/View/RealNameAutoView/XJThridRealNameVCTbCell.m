//
//  XJThridRealNameVCTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJThridRealNameVCTbCell.h"

@interface XJThridRealNameVCTbCell ()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UIImageView *arrowIV;



@end

@implementation XJThridRealNameVCTbCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = defaultLineColor;

        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(8);
            make.right.equalTo(self.contentView).offset(-8);
            make.top.equalTo(self.contentView).offset(8);
            make.bottom.equalTo(self.contentView).offset(0);
        }];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(28);
        }];
        
        self.contentLb.text = @"认证失败?";
        [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.right.equalTo(self.bgView).offset(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
    
}


#pragma mark lazy
- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
    }
    return _bgView;
    
}
- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:YES];
    }
    return _contentLb;
    
}
- (UIImageView *)arrowIV{
    
    if (!_arrowIV) {
        _arrowIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@"icFailMore"];
    }
    return _arrowIV;
    
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
