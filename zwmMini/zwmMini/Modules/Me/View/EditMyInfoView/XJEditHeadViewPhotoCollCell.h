//
//  XJEditHeadViewPhotoCollCell.h
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EdittapPhotoCellBlock)(void);


@interface XJEditHeadViewPhotoCollCell : UICollectionViewCell
@property (nonatomic, strong) UIView *coverBgView;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UIImageView *errorImgView;
@property (nonatomic, strong) UILabel *errorLabel;

@property(nonatomic,copy) EdittapPhotoCellBlock tapBlock;



- (void)setImgWithPhptpModel:(XJPhoto *)model;
@end

NS_ASSUME_NONNULL_END
