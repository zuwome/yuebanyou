//
//  XJRCMImageCollectionViewCell.m
//  zwmMini
//
//  Created by qiming xiao on 2018/12/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRCMImageCollectionViewCell.h"

CGFloat xxWidth = 0.0;

CGFloat xxHeight = 0.0;

@interface  XJRCMImageCollectionViewCell ()

@property(nonatomic,strong) UIImageView *coentBackgroundView;

@property(nonatomic,strong) UIImageView *headIV;

@property(nonatomic,strong) UIImageView *contentBgIV;

@property (nonatomic, strong) UIImageView *picImageView;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@end

@implementation XJRCMImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self creatViews];
    }
    return self;
}


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel: model];
    self.coentBackgroundView.frame = CGRectMake(kScreenWidth - 100, 10, 300 + 40, 300 + 30);
    self.backgroundColor = UIColor.redColor;
    RCImageMessage *imageMessage = (RCImageMessage *)model.content;
    
    _picImageView.image = imageMessage.thumbnailImage;
    _picImageView.contentMode = UIViewContentModeScaleAspectFit;
    // 容云提供的方案
    CGFloat imageWidth = 120;
    CGFloat imageHeight = 120;
    if (imageMessage.thumbnailImage.size.width > 121 || imageMessage.thumbnailImage.size.height > 121) {
        imageWidth = imageMessage.thumbnailImage.size.width / 2.0f;
        imageHeight = imageMessage.thumbnailImage.size.height / 2.0f;
    } else {
        imageWidth = imageMessage.thumbnailImage.size.width;
        imageHeight = imageMessage.thumbnailImage.size.height;
    }
    
    xxWidth = imageWidth + 17;
    xxHeight = imageHeight + 13;
    NSString *extra =  [XJUtils dictionaryWithJsonString:imageMessage.extra][@"payChat"];
    if ([imageMessage.extra isEqualToString:@"PrivateChatPay"]||[extra isEqualToString:@"PrivateChatPay"]) {
        if (model.messageDirection == MessageDirection_SEND) {
            [_picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.coentBackgroundView).offset(14);
                make.right.equalTo(self.coentBackgroundView).offset(-3);
                make.top.equalTo(self.coentBackgroundView).offset(9.5);
                make.bottom.equalTo(self.coentBackgroundView).offset(-2.3);
                make.width.mas_equalTo(imageWidth);
            }];
            
        }
        else{
            [_picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.coentBackgroundView).offset(3);
                make.right.equalTo(self.coentBackgroundView).offset(-14);
                make.top.equalTo(self.coentBackgroundView).offset(9);
                make.bottom.equalTo(self.coentBackgroundView).offset(-2.2);
                make.width.mas_equalTo(imageWidth);
            }];
        }
        
    }else{
        [_picImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coentBackgroundView).offset(0);
            make.right.equalTo(self.coentBackgroundView).offset(0);
            make.top.equalTo(self.coentBackgroundView).offset(0);
            make.bottom.equalTo(self.coentBackgroundView).offset(0);
            make.width.mas_equalTo(imageWidth);
        }];
    }
}


+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{

    return CGSizeMake(xxWidth, xxHeight);
}


#pragma mark - UI
- (void)creatViews {
    [self.baseContentView addSubview:self.headIV];
    [self.baseContentView addSubview:self.coentBackgroundView];
    [self.coentBackgroundView addSubview:self.picImageView];
}

#pragma mark - Setter&Getter
- (UIImageView *)coentBackgroundView{
    if (!_coentBackgroundView) {
        //        _bubbleBackgroundView = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.baseContentView imageUrl:nil placehoderImage:@"chatrechargebgimg"];
        _coentBackgroundView = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
    }
    return _coentBackgroundView;
}

- (UIImageView *)headIV{
    if (!_headIV) {
        _headIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
        _headIV.layer.cornerRadius = 20;
        _headIV.layer.masksToBounds = YES;
    }
    return _headIV;
}

- (UIImageView *)contentBgIV {
    if (!_contentBgIV) {
        _contentBgIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:nil imageUrl:nil placehoderImage:@""];
        
    }
    return _contentBgIV;
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
    }
    return _picImageView;
}

@end
