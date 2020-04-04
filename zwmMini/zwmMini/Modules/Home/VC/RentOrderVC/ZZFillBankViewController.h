//
//  ZZFillBankViewController.h
//  zuwome
//
//  Created by 潘杨 on 2018/6/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "XJBaseVC.h"

/**
 填写银行卡信息
 */
@interface ZZFillBankViewController : XJBaseVC
/**
 当前的提现用户
 */
@property(nonatomic,strong) XJUserModel *user;
@property (nonatomic,assign) BOOL isTiXian;//是否是实名认证到的提现

/**
 提现金额
 */
@property (nonatomic,strong) NSString *tiXianMoney;
/**
 提现成功
 */
@property (nonatomic,copy)  dispatch_block_t  tiXianBlock;
@end
