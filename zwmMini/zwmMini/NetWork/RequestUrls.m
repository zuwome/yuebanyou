//
//  RequestUrls.m
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "RequestUrls.h"

@implementation RequestUrls





NSString* const API_GET_SYSTEM_CONFIG = @"system/config";

NSString* const API_CONUTRY_LIST_GET = @"country/list";

NSString* const API_REGIST_NEXT_POST = @"user/sign/code";

NSString* const API_SENMESSAGE_REGIST_POST = @"sms/send";

NSString* const API_REGIST_POST = @"user/sign/up";

NSString* const API_LOGIN_POST = @"user/sign/in";

NSString* const API_USER_SIGN_CHECK_PHOTO = @"user/check/photo";

NSString* const API_USER_ISLOGIN_CHECK_PHOTO = @"api/user/check/photo";

NSString* const  API_RESET_PASSWORD_POST = @"user/password/reset";

NSString* const  API_CITY_LIST_GET = @"city/list";

NSString* const  API_HOME_GET = @"rents_bycate";

NSString* const  API_ISLOIN_HOME_GET = @"api/rents_bycate";

NSString* const  API_SEARCH_LIST_GET = @"rent/explore2";

NSString* const API_GET_USERINFO_LIST = @"api/user";

NSString* const API_GET__UNLOGIN_USERINFO_LIST = @"user";

NSString* const API_GET_JOBS_LIST = @"system/jobs";

NSString* const API_UPDATA_JOBS = @"api/user2";

NSString* const API_GET_TAGS_LIST = @"system/tags";

NSString* const API_GET_INTERESTS_LIST = @"system/interests";

NSString* const API_GET_PHOTOINFO = @"api/photo";

NSString* const API_CHANGE_PASSWORD_POST = @"api/user/password";

NSString* const H5_USER_USE_PROTOCAL = @"http://v2.zuwome.com/agreementkby";

NSString* const H5_USER_USE_PRI_PROTOCAL = @"http://v2.zuwome.com/agreementknewby";

NSString* const API_ACCOUNT_CANCEL_FIRST_GET = @"api/user/account/status";

NSString* const API_SHIELD_CONTACS_POST = @"api/user/contacts/block";

NSString* const API_CANCEL_SHIELD_CONTACS_POST = @"api/user/contacts/unblock";

NSString* const API_SHIELD_CONTACS_LIST_GET = @"api/user/block/contacts";

NSString* const API_BLANCE_RECORD_GET = @"api/user/capital2";

NSString* const API_M_COIN_RECORD_GET = @"api/user/mcoin_records";

NSString* const API_MY_COIN_GET = @"api/user/mcoin";

NSString* const API_PAY_COIN_DATA_GET = @"system/in_app_purchase/listby";

NSString* const API_MYBALANCE_HINT_GET = @"user/enhance_income_tip";

NSString* const H5_HELP_AND_BACK = @"http://7xwsly.com1.z0.glb.clouddn.com/helper/helpAndfeedback.html?v=12";

NSString* const H5_RECHARGE_PROTOCAL = @"http://picv2.zhangjiamenhu.com/agreement/iosRecharge.html";

NSString* const H5_WITHDRAW_PROTOCAL = @"http://static.zuokeme.com/transfer_rule.html";

NSString* const API_WITHDRAW_POST = @"api/user/transfer";

NSString* const API_LOOKWX_BALANCE_GET = @"api/user/balance";

NSString* const API_LOOKWX_COIN_GET = @"system/in_app_purchase/list_pay_wechatby";

NSString* const API_HAS_LOOK_WX_LIST_GET = @"api/user/wechat_seens";

NSString* const API_BE_LOOK_WX_LIST_GET = @"api/user/wechat_who_see_me";

NSString* const API_GET_RONGIM_TOKEN_GET = @"api/user/rong/token";

NSString* const API_GET_UNREAD_INFO_GET = @"api/user/unread2";

NSString* const API_PHOTOT_IS_HACK_POST = @"photo/ishack";
//NSString* const API_PHOTOT_IS_HACK_POST = @"photo/ishack_bd";


NSString* const API_UPDATE_USER_AVATAR_POST = @"api/user/avatar/add";

NSString* const API_RECHARGE_SUCCESS_POST = @"api/user/mcoin/rechargeby";

NSString* const API_RECHARGE_FAIL_POST = @"api/user/mcoin/recharge/cancel";

NSString* const API_SYTTEMLIST_INFO_GET = @"api/message/system";

NSString* const API_REALNAME_POST = @"api/user/realname";

NSString* const API_REALNAME_FAIL_RE_POST = @"api/user/realname_fail";

NSString* const API_IS_SHOW_POST = @"api/rent/show";

NSString* const API_IS_SHOW_DELETE_POST = @"api/rent/show_delete";

NSString* const API_CHECK_TEXT_POST = @"system/text_detect";

NSString* const API_ACCOUNT_CLOSE_POST = @"api/user/account/close";
//
@end
