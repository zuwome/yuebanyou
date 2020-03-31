//
//  XJLookWxPayCoinVC.h
//  zwmMini
//
//  Created by Batata on 2018/12/7.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^XJLookWxPayCoinVCBlcok)(NSString *coinstr);
@interface XJLookWxPayCoinVC : XJBaseVC

@property(nonatomic,strong) XJUserModel *userModel;
@property(nonatomic,copy) XJLookWxPayCoinVCBlcok successBlcok;
@end

NS_ASSUME_NONNULL_END
