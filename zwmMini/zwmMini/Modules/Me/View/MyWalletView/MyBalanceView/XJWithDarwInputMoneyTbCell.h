//
//  XJWithDarwInputMoneyTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XJWithDarwInputMoneyTbCellDelegate <NSObject>

- (void)moneyText:(NSString *)money;

@end
@interface XJWithDarwInputMoneyTbCell : UITableViewCell
@property(nonatomic,weak) id<XJWithDarwInputMoneyTbCellDelegate> delegate;
- (void)setUpInputFileText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
