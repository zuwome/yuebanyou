//
//  XJEditHeadViewAddPhotoCoCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditHeadViewAddPhotoCoCell.h"


@interface XJEditHeadViewAddPhotoCoCell()

@property(nonatomic,strong) UIImageView *addPhotoIV;
@property(nonatomic,strong) UILabel *addLabel;


@end

@implementation XJEditHeadViewAddPhotoCoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = defaultLineColor;

        [self.addPhotoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(-20);
            make.width.height.mas_equalTo(36);
        }];
        [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.addPhotoIV);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView).offset(25);

        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)tapSelf{
    
    if (self.tapBlock) {
        self.tapBlock();
    }
    
}

- (UIImageView *)addPhotoIV{
    
    if (!_addPhotoIV) {
        
        _addPhotoIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:@"" placehoderImage:@"addphotoimg"];
        _addPhotoIV.backgroundColor = defaultClearColor;
        
    }
    return _addPhotoIV;
    
    
}
- (UILabel *)addLabel{
    
    if (!_addLabel) {
        _addLabel = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"添加照片，展现你的颜值" font:defaultFont(12) textInCenter:YES];
        _addLabel.numberOfLines = 2;
        _addLabel.backgroundColor = defaultClearColor;
        _addLabel.userInteractionEnabled = YES;

    }
    return _addLabel;
}

@end
