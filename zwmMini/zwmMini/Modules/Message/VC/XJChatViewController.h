//
//  XJChatViewController.h
//  zwmMini
//
//  Created by Batata on 2018/12/12.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJChatViewController : RCConversationViewController

@property(nonatomic,assign) BOOL isNeedCharge; //是否需要私信付费  1:是 0:否

@end

NS_ASSUME_NONNULL_END
