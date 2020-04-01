//
//  ZZRentOrderPaymentViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "XJBaseVC.h"
@class ZZRentDropdownModel;
@class ZZOrder;

@interface ZZRentOrderPaymentViewController : XJBaseVC

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) BOOL fromChat;

@property (nonatomic, assign) BOOL isFromTask;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, strong) ZZRentDropdownModel *addressModel;

@property (nonatomic, strong) XJUserModel *user;

@property (copy, nonatomic) dispatch_block_t callBack;

@end
