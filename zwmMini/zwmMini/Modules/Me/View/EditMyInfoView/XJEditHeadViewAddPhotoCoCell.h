//
//  XJEditHeadViewAddPhotoCoCell.h
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^EditAddPhotoCellBlock)(void);

@interface XJEditHeadViewAddPhotoCoCell : UICollectionViewCell

@property(nonatomic,copy) EditAddPhotoCellBlock tapBlock;


@end

NS_ASSUME_NONNULL_END
