//
//  XJPersonalTagsTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/3.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJPersonalTagsTbCell.h"
#import "SKTagView.h"

@interface XJPersonalTagsTbCell ()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong) SKTagView *tagView;

@end

@implementation XJPersonalTagsTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView).offset(-2);
        }];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(15);
            make.left.equalTo(self.bgView).offset(15);
            make.height.mas_lessThanOrEqualTo(50);

        }];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLb.mas_bottom).offset(12);
            make.left.equalTo(self.titleLb);
            make.right.equalTo(self.bgView).offset(-15);
            make.bottom.equalTo(self.bgView).offset(-15);
        }];
     
    }
    return self;
}
- (void)setUpTitle:(NSString *)title Tags:(NSArray *)tags{
    
    self.titleLb.text = title;

    [tags enumerateObjectsUsingBlock:^(XJInterstsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
  
    
    
  
//    
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
- (SKTagView *)tagView{
    
    if (!_tagView) {
        
        _tagView = [[SKTagView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _tagView.lineSpacing = 20;
        _tagView.interitemSpacing = 18;
        _tagView.preferredMaxLayoutWidth = kScreenWidth - 60;
        [self.bgView addSubview:_tagView];
    }
    return _tagView;
    
}

- (UILabel *)titleLb{
    
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:RGB(102, 102, 102) text:@"" font:defaultFont(15) textInCenter:NO];
    }
    return _titleLb;
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
