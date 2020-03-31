//
//  XJPersonalDetailTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/3.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJPersonalDetailTbCellDelegate <NSObject>

@optional
- (void)clickLookoverWxBtn;

@end

@interface XJPersonalDetailTbCell : UITableViewCell

@property(nonatomic,weak) id<XJPersonalDetailTbCellDelegate> delegate;
- (void)setUpPersonalData:(XJUserModel *)model isOneself:(BOOL)oneslef;

@end

NS_ASSUME_NONNULL_END
