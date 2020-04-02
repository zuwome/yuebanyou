//
//  XJSystemCofigModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/10.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SkillCatalogModel;
@class WechatLookModel;
@class XJPriceConfigModel;
@class ZZVersionModel;
@class ZZUpdateModel;
@class ZZSystemYjConfigModel;
@class ZZDisableModuleModel;
@interface XJSystemCofigModel : NSObject

@property (nonatomic, strong) NSDictionary *comments;

// true代表隐藏私信红包
@property (nonatomic, assign) BOOL hide_mmd_private_at_userdetail;

// true代表隐藏个人详情页的连麦按钮
@property (nonatomic, assign) BOOL hide_link_mic;
@property(nonatomic,copy) NSString *config_version;
@property(nonatomic,copy) NSArray<SkillCatalogModel *> *skill_catalog;
@property(nonatomic,copy) NSString *static_version;
@property(nonatomic,assign) NSInteger min_bankcard_transfer;
@property(nonatomic,copy) NSArray *chat_forbidden_words;
@property(nonatomic,strong) WechatLookModel *wechat;

@property (nonatomic, strong) ZZUpdateModel *version;

@property (nonatomic, strong) ZZSystemYjConfigModel *yj;

// 禁止使用的列表
@property (nonatomic, strong) ZZDisableModuleModel *disable_module;

// 出租 邀约优享邀约服务查看微信价格
@property (nonatomic, assign) double order_wechat_price;

// 出租 邀约优享邀约服务查看微信价格 开关
@property (nonatomic, assign) BOOL order_wechat_enable;

@end

@interface SkillCatalogModel : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) NSInteger classify;
@property(nonatomic,copy) NSString *url;

@end

@interface ZZSystemYjConfigModel : NSObject

@property (nonatomic, assign) double order_from;//订单抽佣
@property (nonatomic, assign) double mmd;//么么答抽佣
@property (nonatomic, assign) double mmd_tip;//么么答打赏抽佣
@property (nonatomic, assign) double mmd_private;//私信抽佣
@property (nonatomic, assign) double sk_tip;//时刻打赏抽佣

@end

@interface WechatLookModel : NSObject

@property(nonatomic,copy) NSArray *comment_content;//差评理由

@end

@interface XJPriceConfigModel: NSObject

/**
 *  连麦价格表 json数据为double型，但是在转换的时候可能会丢失精度，因此全部转换成nsstring保证精度正确。
 */
// 每多少分钟结算一次（每个结算单位 消耗X么币）
@property (nonatomic, copy) NSString *settlement_unit;

// 每个结算单位 消耗X么币
@property (nonatomic, copy) NSString *per_unit_cost_mcoin;

// 每次结算需要消耗多少张咨询卡（每个结算单位 4张卡）
@property (nonatomic, copy) NSString *per_unit_cost_card;

// 汇率: 一张咨询卡 = X么币
@property (nonatomic, copy) NSString *one_card_to_mcoin;

// 每个结算单位 用户获得X元: per_unit_cost_mcoin / 10 * 0.7/
@property (nonatomic, copy) NSString *per_unit_get_money;

// 可申请退款时间
@property (nonatomic, copy) NSString *can_refund_time;

// 连麦价格文本
@property (nonatomic, copy) NSDictionary *text;

/**
 *  私信价格
 */
// 每条私信消耗的X么币
@property (nonatomic, copy) NSString *per_chat_cost_mcoin;

// 发送私信，赠送X张私信卡
@property (nonatomic, copy) NSString *per_chat_give_card;

// 每条私信获得X元: per_chat_cost / 10 / 2
@property (nonatomic, copy) NSString *per_chat_get_money;

// 回复信息，领取X张私信卡
@property (nonatomic, copy) NSString *per_chat_get_card;

// 一张私信卡等于X么币
@property (nonatomic, copy) NSString *chat_one_card_to_mcoin;

// 私聊价格文本
@property (nonatomic,   copy) NSDictionary *text_chat;

@end




@interface ZZUpdateModel : NSObject

@property (nonatomic, assign) NSInteger haveNewVersion;

@property (nonatomic, strong) ZZVersionModel *version;

@property (nonatomic, copy) NSString *title;

@end

@interface ZZVersionModel : NSObject

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *version;

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *link;

@property (nonatomic, strong) NSString *createdAt;

@property (nonatomic, assign) NSInteger __v;

@property (nonatomic, copy) NSString *title;

@end

@interface ZZDisableModuleModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *no_have_face;//需要有人脸
@property (nonatomic, strong) NSArray<NSString *> *no_have_face_text;//文本
@property (nonatomic, strong) NSArray<NSString *> *no_have_real_avatar;//需要有头像
@property (nonatomic, strong) NSArray<NSString *> *no_have_real_avatar_text;//文本

@end
