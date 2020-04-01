//
//  ZZRentOrderPayCompleteViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "XJBaseVC.h"
#import "ZZOrder.h"
@class ZZRentDropdownModel;

@interface ZZRentOrderPayCompleteViewController : XJBaseVC

@property (nonatomic, strong) XJUserModel *user;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, strong) ZZRentDropdownModel *addressModel;

@property (copy, nonatomic) dispatch_block_t callBack;

@property (assign, nonatomic) BOOL fromChat;

@end


