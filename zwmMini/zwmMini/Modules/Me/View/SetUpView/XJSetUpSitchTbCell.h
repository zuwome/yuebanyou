//
//  XJSetUpSitchTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/3.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwitchCellBlock)(UISwitch *swi);

@interface XJSetUpSitchTbCell : UITableViewCell

@property(nonatomic,assign) BOOL isNoti;

@property(nonatomic,copy) SwitchCellBlock block;

- (void)setUpTitle:(NSString *)title isOnSwitch:(BOOL)isOn;
@end

NS_ASSUME_NONNULL_END
