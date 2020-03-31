//
//  XJEditinfoTagsTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditinfoTagsTbCell.h"
#import "SKTagView.h"
@interface XJEditinfoTagsTbCell()

@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) SKTagView *tagView;

@end

@implementation XJEditinfoTagsTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *arrowIv = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:nil placehoderImage:@"rightarrwoimg"];
        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.mas_equalTo(6);
            make.height.mas_equalTo(12);
        }];
        
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(arrowIv);
            make.left.equalTo(self.contentView).offset(15);
            make.height.mas_equalTo(50);
        }];
        
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLb);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
//            make.bottom.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.titleLb.mas_bottom);
        }];
    }
    return self;
    
}
- (void)setTagsWithIndexPath:(NSIndexPath *)indexPath{
    
    [self.tagView removeAllTags];
 
    if (indexPath.row == 7) {
        self.titleLb.text = @"个人标签";
        [XJUserAboutManageer.uModel.tags_new enumerateObjectsUsingBlock:^(XJInterstsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SKTag *tag = [SKTag tagWithText:obj.content];
            tag.textColor = UIColor.whiteColor;
            tag.bgColor = defaultWhite;
            tag.fontSize = 12;
            tag.textColor = RGB(102, 102, 102);
            tag.padding = UIEdgeInsetsMake(12, 16, 12, 16);
            tag.cornerRadius = 20;
            tag.borderColor = RGB(102, 102, 102);
            tag.borderWidth = 1;
            [self.tagView addTag:tag];
        }];
    
        
    }else{
        self.titleLb.text = @"兴趣爱好";
        [XJUserAboutManageer.uModel.interests_new enumerateObjectsUsingBlock:^(XJInterstsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SKTag *tag = [SKTag tagWithText:obj.content];
            tag.textColor = UIColor.whiteColor;
            tag.bgColor = defaultWhite;
            tag.fontSize = 12;
            tag.textColor = RGB(102, 102, 102);
            tag.padding = UIEdgeInsetsMake(12, 16, 12, 16);
            tag.cornerRadius = 20;
            tag.borderColor = RGB(102, 102, 102);
            tag.borderWidth = 1;
            [self.tagView addTag:tag];
        }];
        
        
    }
    
}

- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(102, 102, 102) text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _titleLb;
}

- (SKTagView *)tagView{
    
    if (!_tagView) {
        
        _tagView = [[SKTagView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagView.lineSpacing = 20;
        _tagView.interitemSpacing = 18;
        _tagView.preferredMaxLayoutWidth = kScreenWidth - 60;
        [self.contentView addSubview:_tagView];
    }
    return _tagView;
    
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
