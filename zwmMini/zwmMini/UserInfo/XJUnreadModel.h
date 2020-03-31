//
//  XJUnreadModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/12.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XJMessageConfigModel;

NS_ASSUME_NONNULL_BEGIN

@interface XJUnreadModel : NSObject


@property (assign, nonatomic) BOOL open_log;
@property (assign, nonatomic) BOOL ongoing;//订单进行中 false不需要小红点 true需要
@property (assign, nonatomic) BOOL dynamic_following;//动态－我关注的
@property (assign, nonatomic) BOOL my_ask_mmd;//我的么么答－我问
@property (assign, nonatomic) BOOL my_answer_mmd;//我的么么答－我答
@property (assign, nonatomic) BOOL my_mmd;//我的么么答
@property (assign, nonatomic) BOOL dynamic;//动态
@property (assign, nonatomic) BOOL notice_tab;//消息tab栏
@property (assign, nonatomic) BOOL me_tab;//我的tab栏

@property (assign, nonatomic) NSInteger order_ongoing_count;//进行中订单数目
@property (assign, nonatomic) BOOL order_commenting;//待评论订单
@property (assign, nonatomic) BOOL order_done;//已完成订单
@property (assign, nonatomic) NSInteger my_answer_mmd_count;//我的么么答-我答数目
@property (assign, nonatomic) BOOL have_system_red_packet;//true有系统扫脸红包  false没有;
@property (assign, nonatomic) NSInteger red_packet_msg_count;//红包留言未读数
@property (strong, nonatomic) XJMessageConfigModel *say_hi;
@property (strong, nonatomic) NSDictionary *pd;
@property (assign, nonatomic) NSInteger pd_receive;//抢任务数目
@property (copy, nonatomic) NSString *pd_receive_last_time;//最后收到派单任务时间
@property (assign, nonatomic) NSNumber *system_msg;//系统消息
@property (assign, nonatomic) NSNumber *hd;//互动消息
@property (assign, nonatomic) NSNumber *reply;//评论消息



@end


@interface XJMessageConfigModel : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger user_count;
@property (nonatomic, copy) NSString *latest_at;
@property (nonatomic, copy) NSString *latest_at_text;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *videoMessageType;

@end

NS_ASSUME_NONNULL_END
