//
//  XJRongIMManager.h
//  zwmMini
//
//  Created by Batata on 2018/12/12.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XJRongIMManager : NSObject

+ (XJRongIMManager *)sharedInstance;



//连接IM
- (void)connectRongIM;

//退出IM
- (void)logOutRongIM;

//设置消息tabbar红点
- (void)setUpTabbarUnreadNum;

@end

NS_ASSUME_NONNULL_END
