//
//  XJPersonalDataNameTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/3.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJPersonalDataNameTbCell.h"

@interface XJPersonalDataNameTbCell()


@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UIImageView *genderIV;
@property(nonatomic,strong) UIImageView *distanceIV;
@property(nonatomic,strong) UILabel *distanceLb;





@end

@implementation XJPersonalDataNameTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView);
//            make.height.mas_equalTo(89);
        }];
//        self.bgView.backgroundColor = UIColor.orangeColor;
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(15);
            make.top.equalTo(self.bgView).offset(15);
        }];
        
        [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLb);
            make.top.equalTo(self.nameLb.mas_bottom).offset(12);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(20);
            make.bottom.equalTo(self.bgView).offset(-16.0);
            
        }];
        [self.distanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.genderIV);
            make.right.equalTo(self.bgView).offset(-15);
            
        }];
        [self.distanceIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.distanceLb.mas_left).offset(-5);
            make.centerY.equalTo(self.distanceLb);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(11);
        }];
        
    }
    return self;
    
}

-(void)setUpName:(NSString *)name Gender:(BOOL)isboy Distance:(NSString *)distance isOneself:(BOOL)onself{
    self.nameLb.text = name;
    self.genderIV.image = isboy ? GetImage(@"boyimg"):GetImage(@"girlimg");
    if (onself) {
        self.distanceIV.hidden = YES;
        self.distanceLb.hidden = YES;
    }else{
        self.distanceIV.hidden = NULLString(distance)? YES:NO;
        self.distanceLb.hidden = NO;
        self.distanceLb.text = distance;
    }

}


-(UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
        _bgView.layer.shadowOffset = CGSizeMake(1,1);
        _bgView.layer.shadowOpacity = 0.3;
        _bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
    
}
- (UILabel *)nameLb{
    
    if (!_nameLb) {
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView  textColor:[UIColor blackColor] text:@"" font:defaultFont(19) textInCenter:NO];
    }
    return _nameLb;
    
}
- (UIImageView *)genderIV{
    
    if (!_genderIV) {
        _genderIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:@"" placehoderImage:@""];
    }
    return _genderIV;
    
    
}
- (UILabel *)distanceLb{
    
    if (!_distanceLb) {
        _distanceLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView  textColor:defaultBlack text:@"" font:defaultFont(14) textInCenter:NO];
    }
    return _distanceLb;
    
}
- (UIImageView *)distanceIV{
    
    if (!_distanceIV) {
        _distanceIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:@"" placehoderImage:@"distance1"];
    }
    return _distanceIV;
    
    
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
