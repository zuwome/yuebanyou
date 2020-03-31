//
//  XJBillRecordVC.h
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger{
    BillingRecordsStyle_Balance = 0,//余额
    BillingRecordsStyle_MeBi = 1, //么币
} BillingRecordsStyle;

@interface XJBillRecordVC : XJBaseVC

@property(nonatomic,assign) BillingRecordsStyle recordStyle;


@end

NS_ASSUME_NONNULL_END
