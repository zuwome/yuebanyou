//
//  XJRecommondCollectionViewCell.h
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XJHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XJRecommondCollectionViewCell : UICollectionViewCell


- (void)setUpContent:(XJHomeListModel *)model withIndexpath:(NSIndexPath *)indexpath;
@end

NS_ASSUME_NONNULL_END
