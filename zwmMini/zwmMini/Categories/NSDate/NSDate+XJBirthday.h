//
//  NSDate+XJBirthday.h
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (XJBirthday)

+ (NSInteger)ageWithBirthday:(NSDate *)birthday;

@end

NS_ASSUME_NONNULL_END
