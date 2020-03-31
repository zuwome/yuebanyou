//
//  XJSystemInfoTableViewCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJSystemMsgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XJSystemInfoTableViewCell : UITableViewCell


- (void)setUpContent:(XJSystemMsgModel *)model;

@end

NS_ASSUME_NONNULL_END
