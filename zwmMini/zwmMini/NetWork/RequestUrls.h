//
//  RequestUrls.h
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RequestUrls : NSObject

#ifdef DEBUG

#define Old_APIBASE @"http://banyou.movtrip.com/"
#define APIBASE @"http://192.168.31.51:5000/"//@"http://www.movtrip.com/"//@"http://www.movtrip.com/"
#define PICTURE @"http://pic.zhangjiamenhu.com/"  //图片测试

#else

#define Old_APIBASE @"http://www.zuokeme.com/"  //线上
#define APIBASE @"https://zuwome.com/"
#define PICTURE @"http://pic2.zhangjiamenhu.com/"  //图片正式

#endif

/**
 *  获取系统配置信息
 */
extern NSString* const API_GET_SYSTEM_CONFIG;

/**
 *  首页(未登录)
 */
extern NSString* const API_HOME_GET;
/**
 *  首页(已登录)
 */
extern NSString* const API_ISLOIN_HOME_GET;

/**
 *  搜索
 */
extern NSString* const API_SEARCH_LIST_GET;

/**
 *  区号
 */
extern NSString* const API_CONUTRY_LIST_GET;
/**
 *  城市
 */
extern NSString* const API_CITY_LIST_GET;


/**
 *  注册下一步和验证码登录
 */
extern NSString* const API_REGIST_NEXT_POST;

/**
 *  发送注册验证码
 */
extern NSString* const API_SENMESSAGE_REGIST_POST;

/**
 *  注册
 */
extern NSString* const API_REGIST_POST;

/**
 *  登录
 */
extern NSString* const API_LOGIN_POST;

/**
 *  重置密码
 */
extern NSString* const API_RESET_PASSWORD_POST;
/**
 *  校验照片(未登录)
 */
extern NSString* const API_USER_SIGN_CHECK_PHOTO;

/**
 *  校验照片(已登录)
 */
extern NSString* const API_USER_ISLOGIN_CHECK_PHOTO;

/**
 *  获取用户信息(已登录)
 */
extern NSString* const API_GET_USERINFO_LIST;

/**
 *  获取用户信息(未登录登录)
 */
extern NSString* const API_GET__UNLOGIN_USERINFO_LIST;

/**
 *  获取职业列表
 */
extern NSString* const API_GET_JOBS_LIST;
/**
 *  通过url获取图片信息
 */
extern NSString* const API_GET_PHOTOINFO;
/**
 *  更新资料（职业/标签/兴趣爱好等等等）
 */
extern NSString* const API_UPDATA_JOBS;

/**
 *  获取个人标签
 */
extern NSString* const API_GET_TAGS_LIST;
/**
 *  获取兴趣爱好
 */
extern NSString* const API_GET_INTERESTS_LIST;

/**
 *  修改密码
 */
extern NSString* const API_CHANGE_PASSWORD_POST;

/**
 *  注销账号(第一步)
 */
extern NSString* const API_ACCOUNT_CANCEL_FIRST_GET;

/**
 *  注销账号(第二步)
 */
extern NSString* const API_ACCOUNT_CLOSE_POST;

/**
 *  屏蔽通讯录
 */
extern NSString* const API_SHIELD_CONTACS_POST;

/**
 *  取消屏蔽通讯录
 */
extern NSString* const API_CANCEL_SHIELD_CONTACS_POST;

/**
 *  获取屏蔽列表
 */
extern NSString* const API_SHIELD_CONTACS_LIST_GET;

/**
 *  余额记录
 */
extern NSString* const API_BLANCE_RECORD_GET;

/**
 *  么币记录
 */
extern NSString* const API_M_COIN_RECORD_GET;

/**
 *  我的钱包我的么币
 */
extern NSString* const API_MY_COIN_GET;

/**
 *  我的钱包获取么币内购数据
 */
extern NSString* const API_PAY_COIN_DATA_GET;
/**
 *  收入余额小提示html字符串
 */
extern NSString* const API_MYBALANCE_HINT_GET;

/**
 *  帮助和反馈H5
 */
extern NSString* const H5_HELP_AND_BACK;

/**
 *  用户充值协议H5
 */
extern NSString* const H5_RECHARGE_PROTOCAL;

/**
 *  用户使用和隐私协议
 */
extern NSString* const H5_USER_USE_PRI_PROTOCAL;

/**
 *  用户使用和隐私协议
 */
extern NSString* const H5_USER_USE_PROTOCAL;

/**
 *  提现规则H5
 */
extern NSString* const H5_WITHDRAW_PROTOCAL;
/**
 *  提现
 */
extern NSString* const API_WITHDRAW_POST;

/**
 *  查看微信时获取余额
 */
extern NSString* const API_LOOKWX_BALANCE_GET;

/**
 *  查看微信时内购数据
 */
extern NSString* const API_LOOKWX_COIN_GET;

/**
 *  已查看微信号
 */
extern NSString* const API_HAS_LOOK_WX_LIST_GET;

/**
 *  微信被查看记录
 */
extern NSString* const API_BE_LOOK_WX_LIST_GET;

/**
 *  获取融云token
 */
extern NSString* const API_GET_RONGIM_TOKEN_GET;

/**
 *  获取未读信息
 */
extern NSString* const API_GET_UNREAD_INFO_GET;

/**
 *  检查是否是hack
 */
extern NSString* const API_PHOTOT_IS_HACK_POST;

/**
 *  更新头像
 */
extern NSString* const API_UPDATE_USER_AVATAR_POST;

/**
 *  (么币)内购充值成功
 */
extern NSString* const API_RECHARGE_SUCCESS_POST;

/**
 *  (么币)内购充值失败
 */
extern NSString* const API_RECHARGE_FAIL_POST;

/**
 *  (么币)内购充值失败
 */
extern NSString* const API_SYTTEMLIST_INFO_GET;

/**
 *  认证身份证（大陆）
 */
extern NSString* const API_REALNAME_POST;

/**
 *  认证失败重新上传
 */
extern NSString* const API_REALNAME_FAIL_RE_POST;

/**
 *  关闭隐身
 */
extern NSString* const API_IS_SHOW_POST;

/**
 *  开启隐身
 */
extern NSString* const API_IS_SHOW_DELETE_POST;

/**
 *  敏感词检测 type: 1个人签名 2昵称 3公开么么答 4私信么么答 5技能介绍
 */
extern NSString* const API_CHECK_TEXT_POST;



/**
 
 *  获取简单用户信息只有昵称头像uid
 */
#define API_GET_USERINFO_MINI_(uid) [NSString stringWithFormat:@"api/user/%@/mini",uid]
;

/**
 *  购买微信
 */
#define API_BUY_WX_WITH_(uid) [NSString stringWithFormat:@"api/user/%@/wechat/pay_by_mcoin",uid]

/**
 *  评价微信
 */
#define API_EVALUATE_WX_WITH_(uid) [NSString stringWithFormat:@"api/user/%@/wechat/comment",uid]
/**
 *  立即举报微信
 */
#define API_RIGHTNOW_REPORT_WX_WITH_(uid) [NSString stringWithFormat:@"api/user/%@/report",uid]
/**
 *  私信是否收费
 */
#define API_MESSAGE_ISCHARGE_(uid) [NSString stringWithFormat:@"api/user/%@/chatcharge",uid]

//举报用户api/user/%@/report
#define API_REPORT_USER_(uid) [NSString stringWithFormat:@"api/user/%@/report",uid]

//拉黑用户
#define API_ADDTO_BLACK_(uid) [NSString stringWithFormat:@"api/user/%@/black/add",uid]

//取消拉黑
#define API_REMOVE_BLACK_(uid) [NSString stringWithFormat:@"api/user/%@/black/remove",uid]

@end


