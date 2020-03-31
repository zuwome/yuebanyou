//
//  XJEditMyIntroduceVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditMyIntroductionBlock)(NSString *intorStr, NSInteger errorCode);

@interface XJEditMyIntroduceVC : XJBaseVC
@property(nonatomic,copy) EditMyIntroductionBlock myIntroBlock;
@property(nonatomic,copy) NSString *desc;
@end

NS_ASSUME_NONNULL_END
