//
//  XJBannerCollectionCell.m
//  zwmMini
//
//  Created by qiming xiao on 2020/5/30.
//  Copyright © 2020 zuwome. All rights reserved.
//

#import "XJBannerCollectionCell.h"

@interface XJBannerCollectionCell ()

@property (nonatomic, strong) UIImageView *bannerImageView;

@end

@implementation XJBannerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)layout {
    [self addSubview:self.bannerImageView];
    _bannerImageView.frame = self.frame;
    
}

#pragma mark lazy
- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        _bannerImageView.image = [UIImage imageNamed:@"banner"];
        _bannerImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bannerImageView;
}

@end
