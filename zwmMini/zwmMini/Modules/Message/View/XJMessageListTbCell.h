//
//  XJMessageListTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/12.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJMessageListTbCell : RCConversationBaseCell


- (void)setUpContent:(RCConversationModel *)model rcUser:(RCUserInfo *)userInfo;

@end

NS_ASSUME_NONNULL_END
