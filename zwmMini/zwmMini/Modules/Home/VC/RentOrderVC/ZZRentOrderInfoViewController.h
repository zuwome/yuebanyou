//
//  ZZRentOrderInfoViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "XJBaseVC.h"
#import "ZZOrder.h"

typedef NS_ENUM(NSInteger, OrderCellType) {
    CellTypeContent   = 0,
    CellTypeStartTime,
    CellTypeDuration,
    CellTypeLocation,
    
    CellTypePayWallet,
    CellTypePayWechat,
    CellTypePayAliPay,
    
    CellTypeCheckWechat,
};

@interface ZZRentOrderInfoViewController : XJBaseVC

@property (strong, nonatomic) ZZOrder *order;

@property (strong, nonatomic) XJUserModel *user;

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) BOOL fromChat;

@property (copy, nonatomic) dispatch_block_t callBack;

@end

