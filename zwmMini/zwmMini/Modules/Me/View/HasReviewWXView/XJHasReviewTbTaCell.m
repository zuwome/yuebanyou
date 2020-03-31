//
//  XJHasReviewTbTaCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/11.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJHasReviewTbTaCell.h"


@interface XJHasReviewTbTaCell()

@property(nonatomic,strong) UIImageView *headIV;
@property(nonatomic,strong) UIImageView *dianIV;
@property(nonatomic,strong) UILabel *nameLb;
@property(nonatomic,strong) UILabel *wxNoLb;
@property(nonatomic,strong) NSIndexPath *indexpath;


@end

@implementation XJHasReviewTbTaCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.mas_equalTo(70);
        }];
        
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headIV.mas_centerY).offset(-5);
            make.left.equalTo(self.headIV.mas_right).offset(12);
        }];
        
        [self.wxNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headIV.mas_centerY).offset(5);
            make.left.equalTo(self.headIV.mas_right).offset(12);
        }];
        
        [self.dianIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(3.2);
        }];
        
        
        
    }
    return self;
    
    
}

- (void)headAction{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickHeadIndexPaht:)]){
        
        [self.delegate clickHeadIndexPaht:self.indexpath];
    }
    
}


- (void)setUpContent:(XJHasReviewListModel *)model indexPaht:(NSIndexPath *)indexpath{
    
    self.indexpath = indexpath;
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:GetImage(@"morentouxiang")];
    self.nameLb.text = model.user.nickname;
    self.wxNoLb.text = [NSString stringWithFormat:@"微信号：%@",model.wechat_no];
    
}


#pragma mark lazy

- (UIImageView *)headIV{
    
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@""];
        _headIV.layer.cornerRadius = 35;
        _headIV.layer.masksToBounds = YES;
        _headIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headAction)];
        [_headIV addGestureRecognizer:tap];
    }
    return _headIV;
    
}
- (UIImageView *)dianIV{
    
    if (!_dianIV) {
        _dianIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@"hasreviewshapeimg"];
    }
    return _dianIV;
    
}

- (UILabel *)nameLb{
    
    if (!_nameLb) {
        _nameLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _nameLb;
    
}
- (UILabel *)wxNoLb{
    
    if (!_wxNoLb) {
        _wxNoLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"" font:defaultFont(14) textInCenter:NO];
    }
    return _wxNoLb;
    
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
