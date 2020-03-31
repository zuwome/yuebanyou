//
//  XJMyCoinCollectionViewCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJPayCoinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XJMyCoinCollectionViewCell : UICollectionViewCell

- (void)setUpContet:(XJPayCoinModel *)pmodel isSelect:(BOOL)select;
@end

NS_ASSUME_NONNULL_END
