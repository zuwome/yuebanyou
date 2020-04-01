//
//  XJUserModel.h
//  zwmMini
//
//  Created by Batata on 2018/11/19.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJRequestManager.h"

@class XJCityModel;
@class XJBanModel;
@class XJContactPeople;
@class XJInterstsModel;
@class XJStatisDataModel;
@class XJMarkModel;
@class XJPhoto;
@class XJPrivacyConfigModel;
@class XJPushConfigModel;
@class XJQQModel;
@class XJRealNameModel;
@class XJRent;
@class XJSignTastDetailModel;
@class XJWechat;
@class XJWeibo;
@class XJZmxy;

@interface XJUserModel : NSObject

@property(nonatomic,copy) NSString *ZWMId;//么么号
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *nickname;//昵称
@property (strong, nonatomic) NSString *version;//版本号
@property(nonatomic,assign) NSInteger accept_count;//接受订单次数
@property(nonatomic,strong) XJCityModel *address;

@property (assign, nonatomic) NSInteger answer_count;//回答数目
@property (assign, nonatomic) NSInteger answer_count_myask;//我问的 被回答数
@property (copy, nonatomic) NSString *avatar; // 头像
@property (assign, nonatomic) int avatarStatus;////0=>审核不通过 1=>待审核 2=>已审核 3=>待确认
@property(nonatomic,copy) NSArray *avatar_history;//历史头像
@property (copy, nonatomic) NSString *avatar_unpass;//未通过的照片
@property (assign, nonatomic) float balance;//余额
@property(nonatomic,strong) XJBanModel *ban;//封禁

@property (assign, nonatomic) BOOL banFriends;//是否拉黑对方
@property (assign, nonatomic) BOOL banStatus;//封禁状态
@property (assign, nonatomic) NSInteger bebrowsed_count;//浏览数
@property (assign, nonatomic) NSInteger beordered_count;//预约数
@property (assign, nonatomic) NSInteger berefunded_count;
@property (strong, nonatomic) NSString *bio;//自我介绍
@property(assign ,nonatomic) NSInteger bio_status;
@property (copy, nonatomic) NSString *bio_updated_at;
@property (assign,nonatomic)  BOOL can_see_open_charge;//该用户有资格开启私聊付费
@property (assign, nonatomic) BOOL have_wechat_no;//true有微信号
@property (assign, nonatomic) BOOL can_see_wechat_no;//true已查看过微信号
@property (assign, nonatomic) BOOL have_commented_wechat_no;//true已经评论 false未评论
@property (assign, nonatomic) NSInteger wechat_comment_score;//1差评 5好评
@property (copy,nonatomic)  NSArray  *wechat_comment_content;//评价的内容
@property (assign, nonatomic) BOOL can_bad_comment;//false 不可以差评 true可以差评

@property(copy,nonatomic) NSString *clientType;
@property(copy,nonatomic) NSString *country_code;//区号
@property(copy,nonatomic) NSString *created_at;
@property(copy,nonatomic) NSArray *device;
@property (strong, nonatomic) NSMutableArray <XJContactPeople *> *emergency_contacts;//紧急联系人
@property (nonatomic,copy) NSArray *faces;//人脸检测
@property (assign, nonatomic) NSInteger follower_count;//粉丝数
@property (assign, nonatomic) NSInteger following_count;//关注数
@property(assign,nonatomic) float frozen;//冻结资金
@property(assign,nonatomic) NSInteger gender;//1男 2女
@property (nonatomic, assign) NSInteger gender_status;//1 性别ok  2 性别有错且未实名认证
@property(nonatomic,copy) NSString *constellation;//星座
@property (strong, nonatomic) NSDate *birthday;//生日
@property (assign, nonatomic) NSInteger get_hb_count;//获取红包数
@property (assign, nonatomic) float get_hb_price;//获取红包总金额
@property (assign, nonatomic) float get_hb_price_myask;//我问的 获取红包总金额
@property (assign, nonatomic) NSInteger get_like_count;//r获得多少赞
@property (assign, nonatomic) float give_hb_price_myask;//我问的 发送红包总金额
@property (assign, nonatomic) BOOL have_close_account;//是否已经注销了
@property (assign, nonatomic) BOOL have_red_packet;//true有扫脸红包 false没有
@property (assign, nonatomic) BOOL have_system_red_packet;//true有系统扫脸红包  false没有;
@property(nonatomic,assign) NSInteger height;
@property (copy, nonatomic) NSString *heightIn;
@property(nonatomic,assign) NSInteger age;//年龄
@property(copy,nonatomic) NSArray *impressions;
@property (nonatomic, assign) NSInteger integral;//积分
@property (strong, nonatomic) NSMutableArray<XJInterstsModel *> *interests_new;//兴趣
@property (assign, nonatomic) BOOL isShowOpenQchat;////根据颜值 是否显示开启闪聊
@property(copy,nonatomic) NSString *last_accept_order_at;
//@property (strong, nonatomic) XJStatisDataModel *last_days;//过去30天的统计
@property (assign, nonatomic) NSInteger level;//等级
@property(nonatomic,copy) NSArray *loc;
@property (strong, nonatomic) XJMarkModel *mark;//个人状态（飞机 新人）
@property (assign, nonatomic) NSInteger mcoin;//买的么币
@property(assign,nonatomic) NSInteger mcoin_exchange;//兑换的么币
@property(assign,nonatomic) NSInteger mcoin_total;//总的么币
@property (assign, nonatomic) float minPrice;//最低价格
@property (assign, nonatomic) NSInteger mmd_seen_count;//么么答被多少人看
@property (assign, nonatomic) float money_get_by_wechat_no;//微信号收益
@property (copy, nonatomic) NSString *nickname_unpass_reason;//昵称未通过原因
@property(assign ,nonatomic) BOOL open_charge_answer;//是否开启聊天收费
@property (nonatomic, assign) BOOL open_qchat;//是否已经开通闪聊
@property (strong, nonatomic) NSDate *photo_updated_at;
@property (strong, nonatomic) NSMutableArray<XJPhoto *> *photos;//用户头像(模糊处理)
@property (strong, nonatomic) NSMutableArray<XJPhoto *> *photos_origin;//头像(不模糊处理)
@property (assign, nonatomic) float price_for_chat;//不能聊天时弹窗的最低价格
@property (strong, nonatomic) XJPrivacyConfigModel *privacy_config;//隐私配置
@property (strong, nonatomic) XJPushConfigModel *push_config;//推送配置
@property (strong, nonatomic) XJQQModel *qq;
@property(nonatomic,strong) XJWechat *wechat;
@property(nonatomic,strong) XJWeibo *weibo;
@property (strong, nonatomic) XJRealNameModel *realname;//实名认证信息
@property (strong, nonatomic) XJRealNameModel *realname_abroad;//国外和港澳台认证
//realname_fail
@property (assign, nonatomic) double take_red_packet_price;//针对某人获取的红包数目
@property (strong, nonatomic) XJRent *rent;//出租信息
@property (nonatomic, assign) BOOL rent_need_pay;//此人出租需要付费  false：不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）

@property(nonatomic,assign) float score;//么么值
@property(nonatomic,strong) XJSignTastDetailModel *sign_task;//积分梯度
@property (strong, nonatomic) NSMutableArray<XJInterstsModel *> *tags_new;//个人标签
@property (assign,nonatomic)  BOOL today_issign;//用户是否已经签到领取了积分
@property (assign, nonatomic) NSInteger trust_score;//信任值
@property (copy, nonatomic) NSString *trust_score_level;//信任值高
@property (assign, nonatomic) NSInteger video_count;//视频数目
@property (assign, nonatomic) double wechat_price;//查看此人的微信号需要付款的金额
@property (assign, nonatomic) double wechat_price_get;//微信被查看后女方得到的价格
@property (assign, nonatomic) double wechat_price_mcoin;//查看此人的微信号需要付款的么币（iOS要走内购流程，改用这个字段）
@property (copy, nonatomic) NSString *weightIn;
@property(nonatomic,assign) NSInteger weight;//体重
@property (copy, nonatomic) NSString *work;//工作
@property (strong, nonatomic) NSString *distance;//距离
@property (nonatomic, copy) NSString *link_mic_good_comments_count;//好评数
@property (strong, nonatomic) NSMutableArray<XJInterstsModel *> *works_new;//职业
@property (strong, nonatomic) XJZmxy *zmxy;//芝麻信用

// 头像是否在人工审核中 1待审核，2通过，3失败
@property (nonatomic, assign) NSInteger avatar_manual_status;

// 旧的模糊头像 (用于当前照片在审核中)
@property (nonatomic, strong) NSString *old_avatar;

/**
 *  MARK: 旧的可用头像: 是否有旧的可用头像
 */
- (BOOL)didHaveOldAvatar;

/*
 *  头像是否在审核中
 */
- (BOOL)isAvatarManualReviewing;

/**
 *  MARK: 是否拥有真实头像
 */
- (BOOL)didHaveRealAvatar;

+ (void)loadUser:(NSString *)uid param:(NSDictionary *)param;
+ (void)loadUser:(NSString *)uid
           param:(NSDictionary *)param
         succeed:(void (^)(id data,XJRequestError *rError))succeed
         failure:(void (^)(NSError *error))failure;

- (void)getBalance:(requestCallback)next;
@end





//省市
@interface XJCityModel : NSObject

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *province; //!< 省/直辖市
@property (nonatomic, copy) NSString *name;     //!< 市
@property (nonatomic, copy) NSString *code; //!< 城市编码
@property (nonatomic, copy) NSString *center; //!< 城市编码
@property (nonatomic, assign) BOOL hot;
@property (nonatomic, copy) NSString *pinyinName;

@end



//封禁
@interface XJBanModel : NSObject
@property (nonatomic,assign) BOOL friends;
@property (nonatomic,copy) NSString *start_at;
@property (nonatomic,copy) NSString *expire;
@property (nonatomic,copy) NSString *reason;
@property (nonatomic,copy) NSString *cate;//封禁的天数
@property (nonatomic,assign) BOOL forever;//是否永久封禁

@end
//紧急联系人
@interface XJContactPeople : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

@end

//兴趣
@interface XJInterstsModel : NSObject

@property (nonatomic, copy) NSString *labelId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *alias;


@end


//过去30天统计
@interface XJStatisDataModel : NSObject

@property (assign, nonatomic) NSInteger bebrowsed_count;//浏览数
@property (assign, nonatomic) NSInteger beordered_count;//预约数
@property (assign, nonatomic) NSInteger order_respond_rate;//响应率

@end

//个人状态
@interface XJMarkModel : NSObject

@property (nonatomic, assign) BOOL is_flighted_user;
@property (nonatomic, assign) BOOL is_new_rent;
@property (nonatomic, assign) BOOL is_short_distance_user;

@end

//用户头像
@interface XJPhoto : NSObject

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) NSInteger status; // 0表示不通过 1 待审核 2审核通过
@property (assign, nonatomic) NSInteger face_detect_status;//3代表人脸有比对通过 2代表人脸有比对但不通过 1代表人脸未比对
@end

//隐私配置
@interface XJPrivacyConfigModel : NSObject

@property (nonatomic, assign) BOOL open_chat;//已打开 false未打开

@end

//推送配置
@interface XJPushConfigModel : NSObject

@property (nonatomic, assign) BOOL chat;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL reply;
@property (nonatomic, assign) BOOL like;
@property (nonatomic, assign) BOOL tip;
@property (nonatomic, assign) BOOL mmd_following;
@property (nonatomic, assign) BOOL need_sound;
@property (nonatomic, assign) BOOL need_shake;
@property (nonatomic, assign) BOOL red_packet_msg;//红包推送
@property (nonatomic, assign) BOOL red_packet_following;//红包推送
@property (nonatomic, assign) BOOL sk_following;//红包推送
@property (nonatomic, assign) BOOL system_msg;//系统通知
@property (nonatomic, assign) BOOL no_push;//免打扰
@property (nonatomic, assign) BOOL say_hi;//打开打招呼推送
@property (nonatomic, assign) BOOL push_hide_name;//隐藏昵称
@property (nonatomic, copy) NSString *no_push_begin_at;
@property (nonatomic, copy) NSString *no_push_end_at;
@property (nonatomic, assign) BOOL pd_push;//开启抢任务通知
@property (nonatomic, copy) NSString *pd_push_begin_at;
@property (nonatomic, copy) NSString *pd_push_end_at;
@property (nonatomic, assign) BOOL sms_push;//短信通知
@property (nonatomic, assign) BOOL pd_can_push;// 是否需要本地推送(服务端已经做了开关 及 当前时间是否在有效时间段内判断)

@property (nonatomic, assign) BOOL qchat_push;//闪聊广场的打开和关闭的控制
@property (nonatomic, copy) NSString *qchat_push_begin_at;//起始时间
@property (nonatomic, copy) NSString *qchat_push_end_at;//结束时间
@end

//QQ
@interface XJQQModel : NSObject

@property (copy, nonatomic) NSString *openid;

@end


//wechat
@interface XJWechat : NSObject

@property (strong, nonatomic) NSString *wx;
@property (strong, nonatomic) NSString *unionid;
@property (strong, nonatomic) NSString *no;//微信号
@property (assign, nonatomic) NSInteger good_comment_count;//好评数
@property (assign, nonatomic) NSInteger bad_comment_count;// 差评数
@property (assign, nonatomic) NSInteger be_see_time;//被查看数



@end

//weibo
@interface XJWeibo : NSObject
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *userName;//用户名
@property (copy, nonatomic) NSString *iconURL;//头像
@property (copy, nonatomic) NSString *profileURL;//主页
@property (assign, nonatomic) BOOL verified;
@property (copy, nonatomic) NSString *verified_reason;//v头衔
@property (copy, nonatomic) NSString *accessToken;

@end


@class XJRealnamePic;
//实名认证信息
@interface XJRealNameModel : NSObject

@property (strong, nonatomic) NSDate *updated_at;
@property (assign, nonatomic) NSInteger status;//0未认证，1待审核，2审核成功 3不通过
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *code;
@property (strong, nonatomic) XJRealnamePic *pic;

@end

@interface XJRealnamePic : NSObject
@property (copy, nonatomic) NSString *front;
@property (copy, nonatomic) NSString *hold;
@end

//出租信息
@class XJTopicsModel;
@class XJTopic;
@class XJCityModel;
@interface XJRent : NSObject

@property (strong, nonatomic) NSDate *updated_at;
@property (assign, nonatomic) NSInteger status; //0、未出租 1、待审核 2、已上架 3、已下架
@property (assign, nonatomic) BOOL show;
@property (strong, nonatomic) XJCityModel *address;
@property (strong, nonatomic) NSArray *time;
@property (strong, nonatomic) NSString *people;
@property (strong, nonatomic) NSMutableArray<XJTopic *> *topics;

@property (assign, nonatomic) float minPrice;

@property (assign, nonatomic) NSUInteger paid_status; //0未付费（老用户和未付费的新用户都返回0）  1:已过期  2:未过期
@property (copy, nonatomic) NSString *expired_at_text;//会员时间信息 "到期时间2017-12-30"

@property (strong, nonatomic) XJCityModel *city;

@end

//技能
@class XJSkill;
@interface XJTopicsModel : NSObject

@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSMutableArray <XJSkill *> *skills;

@end

//技能详细
@class XJSkillDetail;
@class XJSkillTagModel;
@interface XJSkillModel : NSObject

@property (nonatomic, copy) NSString *id;           //技能id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int type;// 1线下技能  2线上技能
@property (nonatomic, assign) BOOL pass;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *selected_img;
@property (nonatomic, copy) NSString *normal_img;

//2018.8.8  新版出租添加字段
@property (nonatomic, strong) XJSkillDetail *detail;
@property (nonatomic, assign) NSInteger classify;   //主题类型：0休闲，1运动，2时尚，3生活
@property (nonatomic, assign) NSInteger oldType;
//@property (nonatomic ,copy) NSString *_id;
@property (nonatomic ,assign) NSInteger __v;
@property (nonatomic ,assign) NSInteger oldId;
@property (nonatomic ,assign) NSInteger topicStatus;//审核状态：0=>审核不通过 1=>待审核 2=>已审核 3=>待确认 4默认通过
@property (nonatomic ,strong) NSArray<XJPhoto *> *photo;//主题图片
@property (nonatomic, copy) NSString *time;         //档期（空闲时间） 工作日 上午1，下午2，晚上3，深夜4
//              节假日 上午5，下午6，晚上7，深夜8
@property (nonatomic, copy) NSString *price;        //技能主题价格
@property (nonatomic, copy) NSString *pid;          //主题id

@property (nonatomic, copy) NSString *content;      //主题介绍(用于选择系统主题时显示)
@property (nonatomic, copy) NSString *url;          //主题图片地址(用于选择系统主题时显示)
@property (nonatomic, strong) NSArray<XJSkillTagModel *> *tags;
@property (nonatomic, copy) NSString *defaultPhotoUrl;  //系统主题图片


@end

//新版出租添加字段
@interface XJSkillDetail : NSObject

@property (nonatomic, assign) NSInteger status;     //0=>审核不通过 1=>待审核 2=>已审核
@property (nonatomic, copy) NSString *content;

@end

@interface XJSkillTagModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

@end
//积分梯度
@interface XJSignTastDetailModel : NSObject

@property(nonatomic,strong) NSArray *score_list;// 积分梯度 数组
@property(nonatomic,assign) NSNumber *day;// 连续签到天数
@end

//芝麻信用
@interface XJZmxy : NSObject

@property (nonatomic, copy) NSString *openid;


@end

