//
//  ZZRentChooseSkillViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "XJBaseVC.h"
#import "ZZOrder.h"
/**
 *  选择技能
 */
@interface ZZRentChooseSkillViewController : XJBaseVC

@property (strong, nonatomic) XJUserModel *user;
@property (strong, nonatomic) ZZOrder *order;
@property (strong, nonatomic) NSString *uid;
@property (assign, nonatomic) BOOL isEdit;
@property (assign, nonatomic) BOOL fromChat;

@property (copy, nonatomic) dispatch_block_t callBack;

@end
