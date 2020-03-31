//
//  XJChatUtils.h
//  zwmMini
//
//  Created by Batata on 2018/12/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJChatUtils : NSObject

+ (XJChatUtils *)sharedInstance;

@property(nonatomic,strong) UIImageView *lastLabaIV;
@property(nonatomic,strong) AVAudioPlayer *lastavPlayer;
@property(nonatomic,copy) NSString *isFirstOpenChatView;
@property(nonatomic,assign) NSInteger unreadNum;

-(id)getMessageListLastContent:(RCConversationModel *)model rcUser:(RCUserInfo *)userInfo;


- (NSInteger)whatKindMessage:(RCMessageContent *)content;
@end

NS_ASSUME_NONNULL_END
