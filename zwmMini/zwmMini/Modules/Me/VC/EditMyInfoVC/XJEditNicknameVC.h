//
//  XJEditNicknameVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditNickNameBlock)(NSString *newNickname);

@interface XJEditNicknameVC : XJBaseVC
@property(nonatomic,copy) EditNickNameBlock nameBlcok;

@end

NS_ASSUME_NONNULL_END
