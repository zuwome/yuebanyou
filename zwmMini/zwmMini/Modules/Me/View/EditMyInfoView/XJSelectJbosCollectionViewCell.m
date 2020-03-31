//
//  XJSelectJbosCollectionViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/29.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSelectJbosCollectionViewCell.h"

@interface XJSelectJbosCollectionViewCell ()

@property(nonatomic,strong) NSIndexPath *indexpath;

@end

@implementation XJSelectJbosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.titileLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
    
}

- (void)setUpSubJobsDic:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath isSelect:(BOOL )select{
    

    self.titileLb.text = dic[@"content"];
    self.indexpath = indexPath;
    if (select) {
        self.titileLb.layer.borderColor = RGB(254, 83, 108).CGColor;
        self.titileLb.backgroundColor = RGB(254, 83, 108);
        self.titileLb.textColor = UIColor.whiteColor;
    }
    else{
        self.titileLb.layer.borderColor = RGB(122, 122, 122).CGColor;
        self.titileLb.backgroundColor = defaultWhite;
        self.titileLb.textColor = RGB(122, 122, 123);
    }

    
}



- (UILabel *)titileLb{
    
    if (!_titileLb) {


        _titileLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:RGB(133, 133, 133) text:@"" font:defaultFont(12) textInCenter:YES];
        _titileLb.layer.borderColor = RGB(122, 122, 122).CGColor;
        _titileLb.layer.borderWidth = 1;
        _titileLb.backgroundColor = defaultWhite;
        _titileLb.layer.cornerRadius = 5;
        _titileLb.layer.masksToBounds = YES;
//        _titileBtn.titleLabel.font = defaultFont(12);
    }
    return _titileLb;
}

@end

