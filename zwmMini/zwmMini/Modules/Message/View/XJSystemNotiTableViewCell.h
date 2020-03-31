//
//  XJSystemNotiTableViewCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJSystemNotiTableViewCell : RCConversationBaseCell


- (void)setUpSystemInfo:(XJUnreadModel *)unreadModel;

@end

NS_ASSUME_NONNULL_END
