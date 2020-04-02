//
//  ZZOrderRefundViewController.h
//  zuwome
//
//  Created by angBiu on 16/9/13.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "XJBaseVC.h"
#import "ZZOrder.h"

@interface ZZOrderRefundViewController : XJBaseVC

@property (nonatomic, strong) NSString *reasonString;
@property (nonatomic, assign) double percent;
@property (nonatomic, strong) ZZOrder *order;
@property (nonatomic, copy) dispatch_block_t successCallBack;

@end
