//
//  XJEditAgeVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^EditMyAgeBlock)(NSDate *ageDate ,NSString *conStr);

@interface XJEditAgeVC : XJBaseVC

@property(nonatomic,copy) EditMyAgeBlock ageBlock;

- (instancetype)initWithAge:(NSInteger)age con:(NSString *)con birthday:(NSString *)birthday;
@end

NS_ASSUME_NONNULL_END
