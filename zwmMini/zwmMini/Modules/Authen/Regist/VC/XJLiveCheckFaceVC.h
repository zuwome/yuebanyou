//
//  XJLiveCheckFaceVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN


///注册时候的人脸开始验证
@interface XJLiveCheckFaceVC : XJBaseVC

@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSDictionary *praDic;
@property(nonatomic,assign) BOOL isBoy;

@property(nonatomic,assign) BOOL isRegister;

@end

NS_ASSUME_NONNULL_END
