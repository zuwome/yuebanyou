//
//  XJMyTableViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyTableViewCell.h"

@interface XJMyTableViewCell()

@property(nonatomic,strong) UIImageView *IV;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UILabel *mywxExplainLb;


@end

@implementation XJMyTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [self.IV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.mas_equalTo(26);
        }];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.IV.mas_right).offset(12);
            make.centerY.equalTo(self.IV);
        }];
        
        [self.mywxExplainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-35);
            make.centerY.equalTo(self.contentView);
        }];
        
    }
    return self;
    
}

- (void)setUpIndexPath:(NSIndexPath *)indexpath Imge:(NSString *)img Title:(NSString *)title{
    
    if (indexpath.section == 0) {
        self.IV.image = nil;
        self.titleLb.text = title;
        self.titleLb.font = [UIFont boldSystemFontOfSize:17];
        
        self.mywxExplainLb.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self.titleLb mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
        }];
        return;
    }
    
    self.IV.image = GetImage(img);
    self.titleLb.text = title;
    if (indexpath.row == 1) {
        self.mywxExplainLb.hidden = NO;
        
    }else{
        
        self.mywxExplainLb.hidden = YES;

    }
    XJUserModel *umodel = XJUserAboutManageer.uModel;
    if (!NULLString(XJUserAboutManageer.uModel.wechat.no)) {
//        self.mywxExplainLb.hidden = YES;
        self.mywxExplainLb.text = [NSString stringWithFormat:@"打赏收益￥%d",(int)XJUserAboutManageer.uModel.money_get_by_wechat_no];

    }else{
        self.mywxExplainLb.text = @"填微信,得收益";
    }
    
}


- (UIImageView *)IV{
    
    if (!_IV) {
        _IV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
    }
    return _IV;
}
- (UILabel *)titleLb{
    
    if (!_titleLb) {
        
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _titleLb;
}
- (UILabel *)mywxExplainLb{
    
    if (!_mywxExplainLb) {
        
        _mywxExplainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(254, 83, 108) text:@"填微信,得收益" font:defaultFont(15) textInCenter:NO];
        _mywxExplainLb.textAlignment = NSTextAlignmentRight;
    }
    return _mywxExplainLb;
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
