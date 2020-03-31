//
//  XJChatUtils.m
//  zwmMini
//
//  Created by Batata on 2018/12/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJChatUtils.h"
#import "ZZMessageChatWechatPayModel.h"
#import "ZZChatReportModel.h"

@implementation XJChatUtils


static XJChatUtils *ChatManager = nil;

+(XJChatUtils *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ChatManager == nil) {
            ChatManager = [[self alloc]init];
            
        }
    });
    return ChatManager;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ChatManager == nil) {
            ChatManager = [super allocWithZone:zone];
        }
    });
    return ChatManager;
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    return ChatManager;
    
}

- (void)setUnreadNum:(NSInteger)unreadNum{
    
    [[NSUserDefaults standardUserDefaults] setObject:@(unreadNum) forKey:@"unreadnum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSInteger)unreadNum{
    
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"unreadnum"];
    return [num  integerValue];
}

- (NSString *)isFirstOpenChatView{
    
     return  [[NSUserDefaults standardUserDefaults] objectForKey:@"isfirstopenchatview"];
}
- (void)setIsFirstOpenChatView:(NSString *)isFirstOpenChatView{
    
    [[NSUserDefaults standardUserDefaults] setObject:isFirstOpenChatView forKey:@"isfirstopenchatview"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(id)getMessageListLastContent:(RCConversationModel *)model rcUser:(RCUserInfo *)userInfo{
    
    if (NULLString(model.draft)) {
        
        if ([model.lastestMessage isMemberOfClass:[RCTextMessage class]]) {
            RCTextMessage *message = (RCTextMessage *)model.lastestMessage;
            return message.content;
        } else if ([model.lastestMessage isMemberOfClass:[RCImageMessage class]]) {
            return @"[图片]";
        } else if ([model.lastestMessage isMemberOfClass:[RCLocationMessage class]]) {
            return @"[位置]";
        } else if ([model.lastestMessage isMemberOfClass:[RCVoiceMessage class]]) {
            return @"[语音]";
        } else if ([model.lastestMessage isMemberOfClass:[RCRecallNotificationMessage class]]) {
            RCRecallNotificationMessage *message = (RCRecallNotificationMessage *)model.lastestMessage;
            if ([message.operatorId isEqualToString:userInfo.userId]) {
                return [NSString stringWithFormat:@"%@撤回了一条消息",userInfo.name];
            } else {
                return @"你撤回了一条消息";
            }
        } else if([model.lastestMessage isKindOfClass:[RCInformationNotificationMessage class]]) {
            RCInformationNotificationMessage *message = (RCInformationNotificationMessage *)model.lastestMessage;
            return message.message;
        }else if([model.lastestMessage isKindOfClass:[ZZMessageChatWechatPayModel class]]){
            ZZMessageChatWechatPayModel *message = (ZZMessageChatWechatPayModel *)model.lastestMessage;
            return message.conversationDigest;
        }if([model.lastestMessage isKindOfClass:[ZZChatReportModel class]]){
            ZZChatReportModel *message = (ZZChatReportModel *)model.lastestMessage;
            return @"骚扰信息";
        }else {
            
            return @"未知类型";

        }
        
    }else{
        
//        NSString *string = [NSString stringWithFormat:@"[草稿]%@",model.draft];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//        NSRange range = [string rangeOfString:@"[草稿]"];
//        [attributedString addAttribute:NSForegroundColorAttributeName value:defaultRedColor range:range];
//        return attributedString;
        return @"[草稿]";
    }
    
}

- (NSInteger)whatKindMessage:(RCMessageContent *)content{
    
    //文本类型
    if ([content isMemberOfClass:[RCTextMessage class]]) {
        return 0;
    }
    //语音类型
    if ([content isMemberOfClass:[RCVoiceMessage class]]){
        
        return 1;
    }
    //微信支付类型
    if ([content isMemberOfClass:[RCVoiceMessage class]]){
        
        return 2;
    }
    //举报消息类型
    if ([content isMemberOfClass:[ZZChatReportModel class]]){
        
        return 3;
    }
    
    // 图片消息类型
    if ([content isMemberOfClass:[RCImageMessage class]]){
        return 4;
    }
    
    // 地图消息类型
    if ([content isMemberOfClass:[RCLocationMessage class]]){
        return 5;
    }
    return 100;
}

@end
