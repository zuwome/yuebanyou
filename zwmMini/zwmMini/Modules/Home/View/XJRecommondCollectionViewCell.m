//
//  XJRecommondCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRecommondCollectionViewCell.h"

@interface XJRecommondCollectionViewCell ()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UIImageView *genderIV;
@property(nonatomic,strong) UIImageView *kuangIV;


@end


@implementation XJRecommondCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.headIV.frame = CGRectMake(0, 0, (kScreenWidth/2.f) -3.5, (kScreenWidth/2.f) -3.5);
       
        [self.kuangIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(39);
        }];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headIV).offset(-5);
            make.left.equalTo(self.headIV).offset(10);
        }];
        
        [self.genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLb);
            make.left.equalTo(self.nameLb.mas_right).offset(2);
            make.width.mas_equalTo(12);
            make.height.mas_equalTo(12);
        }];
         
        
        
    }
    return self;
}


- (void)setUpContent:(XJHomeListModel *)model withIndexpath:(NSIndexPath *)indexpath{
    
    if (indexpath.row %2 == 0) {
        [self.headIV cornerRadiusViewWithRadius:6 andTopLeft:NO andTopRight:YES andBottomLeft:NO andBottomRight:YES];
    }else{
        
    [self.headIV cornerRadiusViewWithRadius:6 andTopLeft:YES andTopRight:NO andBottomLeft:YES andBottomRight:NO];

    }
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.nameLb.text = model.user.nickname;
    self.genderIV.image = model.user.gender == 1? GetImage(@"boyiimghome"):GetImage(@"girlimghome");
    
}

- (UIImageView *)headIV{
    
    if (!_headIV) {
        
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
        
    }
    return _headIV;
    
    
}
- (UIImageView *)genderIV{
    
    if (!_genderIV) {
        
        _genderIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
        
    }
    return _genderIV;
    
    
}
- (UIImageView *)kuangIV{
    
    if (!_kuangIV) {
        
        _kuangIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@"mask"];
        
    }
    return _kuangIV;
    
    
}
- (UILabel *)nameLb{
    
    if (!_nameLb) {
        
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultWhite text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _nameLb;
}
@end
