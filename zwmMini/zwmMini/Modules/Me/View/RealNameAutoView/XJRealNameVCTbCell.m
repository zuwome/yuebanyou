//
//  XJRealNameVCTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRealNameVCTbCell.h"

@interface XJRealNameVCTbCell()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *cardIV;
@property(nonatomic,strong) UILabel *cardLb;
@property(nonatomic,strong) UIImageView *littlecardIV;
@property(nonatomic,strong) UILabel *littlecardLb;
@property(nonatomic,strong) UILabel *isRealLb;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UIImageView *unrealIV;






@end

@implementation XJRealNameVCTbCell

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
        
        [self.cardIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(20);
            make.left.equalTo(self.bgView).offset(28);
            make.width.mas_equalTo(51);
            make.height.mas_equalTo(51);
        }];
        [self.cardLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.cardIV);
            make.top.equalTo(self.cardIV.mas_bottom).offset(8);
        }];
        
        [self.littlecardIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cardIV);
            make.left.equalTo(self.cardIV.mas_right).offset(14);
            make.width.mas_equalTo(19);
            make.height.mas_equalTo(14);
        }];
        
        [self.littlecardLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.littlecardIV);
            make.left.equalTo(self.littlecardIV.mas_right).offset(5);
        }];
        
        
        [self.isRealLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView).offset(-14);
            make.centerY.equalTo(self.littlecardIV);
        }];
         
        [self.unrealIV mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(self.isRealLb);
             make.right.equalTo(self.isRealLb.mas_left).offset(-3);
             make.width.height.mas_equalTo(11);
         }];
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.littlecardIV);
            make.right.equalTo(self.isRealLb);
            make.bottom.equalTo(self.cardLb);
        }];
        self.contentLb.numberOfLines = 2;
    }
    return self;
    
}

- (void)setUpContentisReal:(NSInteger)isrealType withIndexpath:(NSIndexPath *)indexpath{
    
    NSString *isrealText = @"";        //0未认证，1待审核，2审核成功 3不通过

    switch (isrealType) {
        case 0:
        {
            isrealText = @"未认证";
        }
            break;
        case 1:
        {
            isrealText = @"待审核";

        }
            break;
        case 2:
        {
            isrealText = @"审核成功";

        }
            break;
        case 3:
        {
            isrealText = @"不通过";

        }
            break;
            
        default:
            break;
    }

    if (indexpath.row == 0) {
      
        self.cardIV.image = GetImage(@"realnamedaluimg");
        self.cardLb.text = @"实名认证";
        self.littlecardIV.image = GetImage(@"sfzimg");
        self.littlecardLb.text = @"身份信息认证";
        self.isRealLb.text = isrealText;
        self.contentLb.text = @"持有大陆通用身份证的用户可通过此方式获得实名认证";
        
    }else{
        
        self.cardIV.image = GetImage(@"realnamegatimg");
        self.cardLb.text = @"实名认证";
        self.littlecardIV.image = GetImage(@"sfzimg");
        self.littlecardLb.text = @"港澳台及海外用户";
        self.isRealLb.text = isrealText;
        self.contentLb.text = @"无大陆通用身份证的用户可通过此方式获得实名认证";
        
        
    }
    
}




#pragma mark lazy
- (UIView *)bgView{
    
    if (!_bgView) {
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
    }
    return _bgView;
    
}

- (UIImageView *)cardIV{
    
    if (!_cardIV) {
        _cardIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@""];
    }
    return _cardIV;
    
}
- (UIImageView *)littlecardIV{
    
    if (!_littlecardIV) {
        _littlecardIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@""];
    }
    return _littlecardIV;
    
}
- (UILabel *)cardLb{
    if (!_cardLb) {
        _cardLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultRedColor text:@"" font:defaultFont(15) textInCenter:YES];
    }
    return _cardLb;
    
}
- (UILabel *)littlecardLb{
    if (!_littlecardLb) {
        _littlecardLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultBlack text:@"" font:defaultFont(14) textInCenter:YES];
    }
    return _littlecardLb;
    
}
- (UILabel *)isRealLb{
    if (!_isRealLb) {
        _isRealLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultGray text:@"" font:defaultFont(11) textInCenter:YES];
    }
    return _isRealLb;
    
}
- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultGray text:@"" font:defaultFont(12) textInCenter:NO];
    }
    return _contentLb;
    
}
- (UIImageView *)unrealIV{
    if (!_unrealIV) {
        _unrealIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@"urealimg"];
        
    }
    return _unrealIV;
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
