//
//  XJBeReviewTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/11.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJHasReviewListModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol XJBeReviewTBCellDelegate <NSObject>

- (void)clickHeadIndexPaht:(NSIndexPath *)indexPath;

@end

@interface XJBeReviewTbCell : UITableViewCell

@property(nonatomic,weak) id<XJBeReviewTBCellDelegate> delegate;

- (void)setUpContent:(XJHasReviewListModel *)model indexPaht:(NSIndexPath *)indexpath;
@end

NS_ASSUME_NONNULL_END
