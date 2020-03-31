//
//  XJMyWalletContentTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XJMyWalletContentTbCellDelegate <NSObject>

- (void)clickBlance;
- (void)clickCoin;

@end

@interface XJMyWalletContentTbCell : UITableViewCell

@property(nonatomic,weak) id<XJMyWalletContentTbCellDelegate> delegate;
- (void)setUpContent:(XJUserModel *)model;


@end

NS_ASSUME_NONNULL_END
