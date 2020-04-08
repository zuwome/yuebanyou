//
//  XJChatViewController.m
//  zwmMini
//
//  Created by Batata on 2018/12/12.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJChatViewController.h"
#import "XJLookWxPayCoinVC.h"
#import "XJMsgInputTophintView.h"
#import "XJRCMTextsCollectionViewCell.h"
#import "XJRCMVoiceeCollectionViewCell.h"
#import "XJFirstOpenChatHintVC.h"
#import "ZZMessageChatWechatPayModel.h"
#import "XJChatPayCollectionViewCell.h"
#import "XJNoEvaluateVC.h"
#import "ZZChatReportModel.h"
#import "XJRCMReportCollectionViewCell.h"
#import "UIActionSheet+Blocks.h"
#import "XJLookoverOtherUserVC.h"
#import "ZZChatOrderInfoCell.h"
#import "ZZChatBaseModel.h"
#import "NSObject+Extensions.h"
#import "ZZPrivateDiffusionView.h"
#import "ZZPrivateChatPayMoneyView.h"
#import "ZZPrivateChatShowMoneyView.h"
#import "JX_GCDTimerManager.h"
#import "PPCounter.h"
#import "UIViewController+XJShowSeletcController.h"
#import "UIImagePickerController+Block.h"
#import "AFNetworking.h"
#import "TZImagePickerController.h"
#import "XJRCMImageCollectionViewCell.h"
#import "ZZChatOrderInfoModel.h"
#import "ZZChatServerViewController.h"
#import "ZZOrderDetailViewController.h"
#import "ZZOrder.h"
#import "ZZChatOrderStatusView.h"
#import "ZZChatStatusSheetView.h"
#import "ZZPayViewController.h"
#import "ZZChatOrderDealView.h"
#import "ZZOrderTalentShowViewController.h"
#import "ZZNewOrderRefundOptionsViewController.h"
#import "ZZRentChooseSkillViewController.h"
#import "XJEditMyInfoVC.h"
#import "ZZMessage.h"
#import "ZZOrderTimeLineView.h"
#import "ZZOrderCommentViewController.h"

#import "ZZPrivateChatPayModel.h"
#import "ZZPrivateChatPayManager.h"

static NSString *PrivateChatPay = @"PrivateChatPay";
static NSString *RCMTextCell = @"rcmtextcell";

@interface XJChatViewController () <RCChatSessionInputBarControlDelegate> {
    BOOL                        _isFrom;
}
@property(nonatomic,assign) NSInteger currentMcoin;//当前m币
@property(nonatomic,strong) XJMsgInputTophintView *topHintView;
@property(nonatomic,assign) BOOL isBlack;

@property (nonatomic, strong) ZZPrivateChatShowMoneyView *showTodayEarnings;
@property (nonatomic,assign) BOOL isEndAnimation;//动画是否结束了

@property(nonatomic,assign) BOOL hasreceive;
@property(nonatomic,assign) BOOL isfirstopen;


@property(nonatomic,assign) NSInteger unreadnum;
@property(nonatomic,assign) NSInteger hassendnum;

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, strong) ZZChatOrderStatusView *statusView;

@property (nonatomic, strong) ZZChatStatusSheetView *sheetView;

@property (nonatomic, assign) CGFloat orderStatusHeight;//顶部订单状态高度

@property (nonatomic, strong) ZZChatOrderDealView *dealView;

@property (nonatomic, strong) XJUserModel *user;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) ZZOrderTimeLineView *timeLineView;

@property (nonatomic, strong) ZZPrivateChatPayModel *payChatModel;//当前聊天的用户的私聊收费的model

@end

@implementation XJChatViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableUnreadMessageIcon = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self fetchBalance];
    
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [self registerClass:[XJRCMTextsCollectionViewCell class] forMessageClass:[RCTextMessage class]];
    [self registerClass:[ZZChatOrderInfoCell class] forMessageClass:[ZZChatOrderInfoModel class]];
    
    [self registerClass:[XJRCMVoiceeCollectionViewCell class] forMessageClass:[RCVoiceMessage class]];
    
    [self registerClass:[XJChatPayCollectionViewCell class] forMessageClass:[ZZMessageChatWechatPayModel class]];
    [self registerClass:[XJRCMReportCollectionViewCell class] forMessageClass:[ZZChatReportModel class]];
//    [self registerClass:[XJRCMImageCollectionViewCell class] forMessageClass:[RCImageMessage class]];

    [self ceratRightView];
    
    //收到消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNofitication:) name:chatVieewReceiveMessagtNoti object:nil];
    if (NULLString([XJChatUtils sharedInstance].isFirstOpenChatView)) {
        
        if (!self.isNeedCharge && XJUserAboutManageer.uModel.gender == 1) {
            return;
        }
        [XJChatUtils sharedInstance].isFirstOpenChatView = @"noFirstOpenChatView";;
        XJFirstOpenChatHintVC *hintVC = [XJFirstOpenChatHintVC new];
//        self.definesPresentationContext = YES;
        hintVC.isNeedCharge = self.isNeedCharge;
        if (XJUserAboutManageer.uModel.gender == 2) {
            hintVC.isNeedCharge = NO;
        }
        hintVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:hintVC animated:YES completion:nil];
    }
    [self addHintView];
    //是否已被拉黑
    [self getBlackStatus];
    
    [self getSendUserInfo];
//    [self fetchTodaysProfits];
//    RCMessageModel *msgmodel = self.conversationDataRepository[0];
//    RCTextMessage *test = (RCTextMessage *)msgmodel.content;
//    NSLog(@"%@",test.extra);
    self.chatSessionInputBarControl.delegate = self;
    
    [self privateChatPayManagerCallBack:nil];
    
    [self fetchLastOrder];

}

#pragma mark - 私聊付费模块
- (void)privateChatPayManagerCallBack:(void(^)(ZZPrivateChatPayModel *payModel))privateChatPayCallBack {
    [ZZPrivateChatPayManager requestUserInfoAndSensitiveNumberWithUid:self.targetId privateChatPay:^(ZZPrivateChatPayModel *payModel) {
        NSLog(@"PY_当前的用户是否可以私聊付费%d",payModel.isPay);
//        [ZZUserHelper shareInstance].consumptionMebi = 0;
        self.payChatModel = payModel;
        //为过审，隐藏私信付费弹窗
//        [self alertPayChatprompt];
        self.payChatModel.isFirst = YES;
        if (privateChatPayCallBack) {
            privateChatPayCallBack(payModel);
        }
    }];
}

- (void)askForAPrivateChatFeeAgain {
     NSLog(@"PY_开始请求私聊付费的数据");
    [ZZPrivateChatPayManager requestUserInfoWithUid:self.targetId privateChatPay:^(ZZPrivateChatPayModel *payModel) {
        self.payChatModel.globaChatCharge = payModel.globaChatCharge;
        self.payChatModel.open_charge = payModel.open_charge;
        self.payChatModel.chatUserVersion = payModel.chatUserVersion;
        self.payChatModel.bothfollowing = payModel.bothfollowing;
        self.payChatModel.ordering = payModel.ordering;
        self.payChatModel.isFirst = NO;
    }];
}


- (void)ceratRightView {
    
    self.showTodayEarnings.frame = CGRectMake(-56, kScreenHeight/3, 83, 54);
    self.showTodayEarnings.hidden = YES;
    self.isEndAnimation = NO;
    self.unreadnum = self.unReadMessage;
    self.hasreceive = self.unReadMessage > 0 ? YES:NO;
    self.hassendnum = 0;
    self.isfirstopen = YES;

    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 28, 28)];
    bt.titleLabel.font = [UIFont systemFontOfSize:11];
    [bt setTitleColor:RGBA(49, 195, 124,1) forState:UIControlStateNormal];
    [bt setImage:GetImage(@"diandiandian") forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(rigthAction) forControlEvents:UIControlEventTouchUpInside];
    bt.selected = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bt];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
}

- (void)addHintView{
    if (!self.isNeedCharge && XJUserAboutManageer.uModel.gender == 1) {
        return;
    }
    CGRect fram = self.conversationMessageCollectionView.frame;
    fram.origin.y = fram.origin.y+ 20;
    fram.size.height = fram.size.height - 20;
    self.conversationMessageCollectionView.frame = fram;
    self.conversationMessageCollectionView.backgroundColor = defaultLineColor;
    
    XJPriceConfigModel *model = XJUserAboutManageer.priceConfig;
    [self.view addSubview:self.topHintView];
    NSString *hintStr = self.isNeedCharge ? model.text_chat[@"send_need_cost"] : model.text_chat[@"answer_get_money"];
    if (self.isNeedCharge && XJUserAboutManageer.uModel.gender == 2) {
        hintStr = model.text_chat[@"send_and_answer"];//@"每条私信收益1元 回复领取并赠送1颗私信宝";
    }
    self.topHintView.hintText = hintStr;
}

//获取发送者资料
- (void)getSendUserInfo{
    [AskManager GET:[NSString stringWithFormat:@"%@/%@",API_GET_USERINFO_LIST,self.targetId] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
            _user = umodel;
            if (umodel.gender == 1) {
                [self fetchTodaysProfits:umodel.uid];
            }
        }
    } failure:^(NSError *error) {

    }];
}

- (void)fetchBalance {
    [AskManager GET:API_MY_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJUserModel *oldmdel = XJUserAboutManageer.uModel;
            oldmdel.mcoin = [data[@"mcoin"] integerValue];
            oldmdel.balance = [data[@"balance"] floatValue];
            XJUserAboutManageer.uModel = oldmdel;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)rigthAction{
    
    NSString *balckstr = self.isBlack ? @"取消拉黑":@"拉黑";
    
    [UIActionSheet showInView:self.view withTitle:@"提示" cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看用户主页" otherButtonTitles:@[@"举报",balckstr] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        
        NSLog(@"%ld",(long)buttonIndex);
        
        switch (buttonIndex) {
            case 0:
            {
                [MBManager showLoading];
                [AskManager GET:[NSString stringWithFormat:@"%@/%@",API_GET_USERINFO_LIST,self.targetId] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
                    
                    XJUserModel *lookuserModel = [XJUserModel yy_modelWithDictionary:data];
                    if (lookuserModel.banStatus) {
                        [MBManager showBriefAlert:@"该用户当前处于被封禁状态，无法进行此操作"];
                        return;
                    }
                    XJLookoverOtherUserVC *lookvc = [XJLookoverOtherUserVC new];
                    lookvc.topUserModel = lookuserModel;
                    [self.navigationController pushViewController:lookvc animated:YES];
                   
                    
                    [MBManager hideAlert];
                } failure:^(NSError *error) {
                    [MBManager hideAlert];
                }];

            }
                break;
            case 1:
            {
                [self reportUser:self.targetId wechatStr:@""];
            }
                break;
            case 2:
            {
                [self addUserToBlack:self.targetId];
            }
                break;
                
            default:
                break;
        }
        
    }];
}

//发送消息
- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent {
    if ([XJUserAboutManageer isUserBanned]) {
//        [MBManager showBriefAlert:@"您已被封禁"];
        return;
    }
    NSLog(@"%@",messageContent);
    
    NSMutableDictionary *extraDic;
    // 小于30需要校验敏感词
    BOOL isneedCheck = self.conversationDataRepository.count <= 30 ? YES : NO;
    
    if (self.payChatModel.isRequessSuccess && self.payChatModel.isPay && !self.payChatModel.wechat_flag && !self.payChatModel.following_flag) {
        // 需要付费
        
        // 么币不足去充值
        if (self.currentMcoin < [XJUserAboutManageer.priceConfig.per_chat_cost_mcoin integerValue]) {
            [self gotoPayVC:[XJUserAboutManageer.priceConfig.per_chat_cost_mcoin integerValue]];
            return;
        }
        

    extraDic = isneedCheck ? @{@"payChat":PrivateChatPay,@"check":@(isneedCheck)}.mutableCopy:@{@"payChat":PrivateChatPay,@"check":@(isneedCheck)}.mutableCopy;
        [self askForAPrivateChatFeeAgain];
    }else{
        // 不需要付费
        extraDic = @{@"payChat":@"",@"check":@(isneedCheck)}.mutableCopy;
    }
    
    switch ([[XJChatUtils sharedInstance] whatKindMessage:messageContent]) {
        case 0:
            // 文本类型
        {
            extraDic[@"ask_for_contact"] = @"true";
            RCTextMessage *msg = (RCTextMessage *)messageContent;
            
            // 本地检测敏感词
            __block BOOL containViolateWord = NO;
            [XJUserAboutManageer.sysCofigModel.chat_forbidden_words enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *word = (NSString *)obj;
                    if ([msg.content rangeOfString:word].location != NSNotFound) {
                        containViolateWord = YES;
                        *stop = YES;
                    }
                }
            }];
            
            // 如果检测到，则弹出提示是否撤回消息
            if (containViolateWord) {
                [self.view endEditing:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"不良信息提示" message:@"请注意,发送不良信息会被封号处理,请遵守社区规则" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"撤回" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    [self.chatSessionInputBarControl.inputTextView becomeFirstResponder];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"发送" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    msg.extra = [XJUtils dictionaryToJson:extraDic];
                    [self sendMsg:(RCMessageContent *)msg pushContent:pushContent];
                }];
                [alert addAction:continueAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            msg.extra = [XJUtils dictionaryToJson:extraDic];
            [self sendMsg:(RCMessageContent *)msg pushContent:pushContent];
        }
            break;
        case 1:
            // 语音类型
        {
            RCVoiceMessage *msg = (RCVoiceMessage *)messageContent;
            msg.extra = [XJUtils dictionaryToJson:extraDic];
            [self sendMsg:(RCMessageContent *)msg pushContent:pushContent];
        }
            break;
//        case 3:
//           // 举报类型
//        {
//            ZZChatReportModel *msg = (ZZChatReportModel *)messageContent;
//            msg.extra = [XJUtils dictionaryToJson:extraDic];
//            [self sendMsg:(RCMessageContent *)msg pushContent:pushContent];
//        }
//            break;
            
        case 4: {
            // 图片
            extraDic[@"ask_for_contact"] = @"true";
            RCImageMessage *msg = (RCImageMessage *)messageContent;
            msg.extra = [XJUtils dictionaryToJson:extraDic];
            [self sendMsg:(RCMessageContent *)msg pushContent:pushContent];
            break;
        }
        case 5: {
            // 地址
            extraDic[@"ask_for_contact"] = @"true";
            RCLocationMessage *msg = (RCLocationMessage *)messageContent;
            msg.extra = [XJUtils dictionaryToJson:extraDic];
            [self sendMsg:(RCMessageContent *)msg pushContent:pushContent];
            break;
        }
            
        default://其他
        {
            
            [self sendMsg:messageContent pushContent:pushContent];

        }
            break;
    }
}

//校验是否是纯数字
- (BOOL)isNumber:(NSString *)strValue
{
    if (strValue == nil || [strValue length] <= 0 || strValue.length<6 || strValue.length >20)
    {
        return NO;
    }
   
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}



- (void)sendMsg:(RCMessageContent *)messagecontent pushContent:(NSString *)pushContent{
    if ([XJUserAboutManageer isUserBanned]) {
        return;
    }
    if ([messagecontent isKindOfClass: [RCImageMessage class]]) {
        [[RCIM sharedRCIM] sendMediaMessage:self.conversationType targetId:self.targetId content:messagecontent pushContent:nil pushData:nil progress:^(int progress, long messageId) {
            
        } success:^(long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (XJUserAboutManageer.uModel.gender == 2 && self.hasreceive) {
                    
                    //                if (self.unreadnum != 0) {
                    //                    NSInteger total = self.unreadnum + self.hassendnum;
                    //                    self.unreadnum = 0;
                    //                    [self showReceiveMoneyAnimation:total];
                    //                }
                    
                    if (self.unReadMessage == self.unreadnum) {
                        [self showReceiveMoneyAnimation:self.unreadnum];
                    }else{
                        [self showReceiveMoneyAnimation:self.hassendnum];
                    }
                }
            });
            
            NSLog(@"消息发送成功");
            if (self.isNeedCharge) {
                self.currentMcoin -= [XJUserAboutManageer.priceConfig.per_chat_cost_mcoin integerValue];
            }
            
        } error:^(RCErrorCode errorCode, long messageId) {
            NSLog(@"send fail:%ld",(long)errorCode);
        } cancel:^(long messageId) {
            
        }];
        
        return ;
    }
    
    RCMessage *message =  [[RCIM sharedRCIM] sendMessage:self.conversationType
                                                targetId:self.targetId
                                                 content:messagecontent
                                             pushContent:nil
                                                pushData:nil
                                                 success:^(long messageId) {
        NSLog(@"%ld",(long)self.unreadnum);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (XJUserAboutManageer.uModel.gender == 2 && self.hasreceive) {
                
//                if (self.unreadnum != 0) {
//                    NSInteger total = self.unreadnum + self.hassendnum;
//                    self.unreadnum = 0;
//                    [self showReceiveMoneyAnimation:total];
//                }
                
                if (self.unReadMessage == self.unreadnum) {
                    [self showReceiveMoneyAnimation:self.unreadnum];
                }else{
                    [self showReceiveMoneyAnimation:self.hassendnum];
                }
            }
        });
                                                     
        NSLog(@"消息发送成功");
        if (self.isNeedCharge) {
            self.currentMcoin -= [XJUserAboutManageer.priceConfig.per_chat_cost_mcoin integerValue];
        }
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"send fail:%ld",(long)nErrorCode);
        
    }];
}

- (void)didTapCellPortrait:(NSString *)userId {
    XJUserModel *userModel = [[XJUserModel alloc] init];
    userModel.uid = userId;
    XJLookoverOtherUserVC *otherVC = [XJLookoverOtherUserVC new];
    otherVC.topUserModel = userModel;
    [self.navigationController pushViewController:otherVC animated:YES];
}

- (void)didTapMessageCell:(RCMessageModel *)model{
    
    if (![model.content isMemberOfClass:[RCVoiceMessage class]]) {
        [super didTapMessageCell:model];
    }
    
    if ([model.content isMemberOfClass:[ZZChatReportModel class]]) {
      //举报类型
      NSLog(@"立即举报");

      [MBManager showWaitingWithTitle:@"举报中"];
      [AskManager GET:[NSString stringWithFormat:@"%@/%@",API_GET_USERINFO_LIST,model.senderUserId] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
          [MBManager hideAlert];
          if (!rError) {
              XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
              NSString *wechastr = NULLString(umodel.wechat.no) ? @"":umodel.wechat.no;

              [self reportUser:model.senderUserId wechatStr:wechastr];
              
          }
          
          
      } failure:^(NSError *error) {
          
      }];
      
  }
  if ([model.content isMemberOfClass:[ZZMessageChatWechatPayModel class]]) {
      // paychat类型
//        NSLog(@"selfid = %@   fromid = %@  targetid = %@",XJUserAboutManageer.uModel.uid,model.senderUserId,model.targetId);
        //我查看了别人就可以看评价了什么(付款方)
            ZZMessageChatWechatPayModel *text = (ZZMessageChatWechatPayModel *)model.content;
        
            if ([text.pay_type integerValue] == 2) {
                [AskManager GET:[NSString stringWithFormat:@"%@/%@",API_GET_USERINFO_LIST,model.targetId] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
                    
                    if (!rError) {
                        XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
                        //已评价弹出评价
                        if (umodel.have_commented_wechat_no) {
                            
                            XJNoEvaluateVC *noValuatVC = [XJNoEvaluateVC new];
                            noValuatVC.userModel = umodel;
                            //            self.definesPresentationContext = YES;
                            noValuatVC.isEvaluate = YES;
                            noValuatVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                            [self presentViewController:noValuatVC animated:YES completion:nil];
                            
                        }else{
                            
                            XJNoEvaluateVC *noValuatVC = [XJNoEvaluateVC new];
                            noValuatVC.userModel = umodel;
                            //            self.definesPresentationContext = YES;
                            noValuatVC.isEvaluate = NO;
                            noValuatVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                            [self presentViewController:noValuatVC animated:YES completion:nil];
                            
                        }
                        
                    }
                    
                    
                } failure:^(NSError *error) {
                    
                }];
            }
    }
}

// 跳出付款界面
- (void)gotoPayVC:(NSInteger)minmunCost {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XJLookWxPayCoinVC *coinVC = [XJLookWxPayCoinVC new];
        XJUserModel *userModel = [XJUserModel new];
        userModel.wechat_price_mcoin = minmunCost;
        coinVC.userModel = userModel;
        self.definesPresentationContext = YES;
        coinVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:coinVC animated:YES completion:nil];
        
        coinVC.successBlcok = ^(NSString * _Nonnull coinstr) {
            self.currentMcoin = [coinstr integerValue];
            NSLog(@"充值成功");
        };
    });
    return;
}

//充值成功刷新coin
- (void)rechageSuccess{
    [self getCoinBalanceData];
}

//举报
- (void)reportUser:(NSString *)uid wechatStr:(NSString *)wechatstr{
    [AskManager POST:API_RIGHTNOW_REPORT_WX_WITH_(uid) dict:@{@"content":wechatstr,@"type":@"1"}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            [MBManager showBriefAlert:@"谢谢您的举报，我们将在2个工作日内解决!"];
        }
        else {
            [MBManager showBriefAlert:rError.message];
        }
//        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        [MBManager hideAlert];
        
    }];
}

//是否已被拉黑
- (void)getBlackStatus {
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:self.targetId success:^(int bizStatus) {
        if (bizStatus == 0) {
            self.isBlack = YES;
        } else {
            self.isBlack = NO;
        }
    } error:^(RCErrorCode status) {
        
    }];
    
}

// 拉黑
- (void)addUserToBlack:(NSString *)uid{
    NSString *url = self.isBlack ? API_REMOVE_BLACK_(uid):API_ADDTO_BLACK_(uid);
    
    [AskManager POST:url dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            if (self.isBlack) {
                [[RCIMClient sharedRCIMClient] removeFromBlacklist:uid success:^{
                   
                    [MBManager showBriefAlert:@"已取消拉黑"];
                    self.isBlack = NO;

                } error:^(RCErrorCode status) {
                    [MBManager showBriefAlert:@"取消拉黑失败"];

                }];
            }else{
                [[RCIMClient sharedRCIMClient] addToBlacklist:uid success:^{
                    [MBManager showBriefAlert:@"已拉黑"];
                    self.isBlack = YES;
                } error:^(RCErrorCode status) {
                    [MBManager showBriefAlert:@"拉黑失败"];
                }];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

////收到消息通知
- (void)receiveMessageNofitication:(NSNotification *)notification{
    NSLog(@"========%@",notification);
    RCMessage *message = [notification.userInfo objectForKey:@"message"];
    self.hasreceive = YES;
    self.hassendnum += 1;
}

// 回复收费消息动画（原来copy来的改的建议重写很乱）
- (void)showReceiveMoneyAnimation:(NSInteger)repeatNumber{
    NSInteger firstdisplaynum = (self.unReadMessage == self.unreadnum && self.isfirstopen) ? 0:self.unreadnum;
    
    NSInteger lastnum = (self.unReadMessage == self.unreadnum && self.isfirstopen) ? 0:self.unreadnum;
        self.showTodayEarnings.getPrivateChatMoneyLab.text = [NSString stringWithFormat:@"%ld",(long)lastnum];
        
        self.showTodayEarnings.hidden = NO;
        self.showTodayEarnings.frame = CGRectMake(16, kScreenHeight/3, 83, 54);
        
        if (self.isEndAnimation ) {
            [self.showTodayEarnings addAnimationWithFromCGPoint:CGPointMake(-41, self.showTodayEarnings.center.y) endPoint:CGPointMake(56.5, self.showTodayEarnings.center.y) andWaitTime:0.1 animationKey:@"starflyMoneyCoin"];
        }
        
        [NSObject asyncWaitingWithTime:1 completeBlock:^{
            
            ZZPrivateChatPayMoneyView *flyMoney = [[ZZPrivateChatPayMoneyView alloc]initWithFrame:CGRectMake(19, self.showTodayEarnings.center.y-88, 24, 24) ImageName:@"icMebiQipaoEnter_Fly"];
            [self.view addSubview:flyMoney];
            
            
//            if (repeatNumber>1) {
                ZZPrivateDiffusionView *flyMoneySpread1 = [[ZZPrivateDiffusionView alloc]initWithFrame:CGRectMake(19, self.showTodayEarnings.mj_y+6, 25, 25)];
                [self.view addSubview:flyMoneySpread1];
                ZZPrivateChatPayMoneyView *showMoneyImage = [[ZZPrivateChatPayMoneyView alloc]initWithFrame:CGRectMake(17, self.showTodayEarnings.mj_y+4, 28, 28) ImageName:@"icMebiQipaoEnter_Fly"];
                [self.view addSubview:showMoneyImage];
                
                [NSObject asyncWaitingWithTime:0.3 completeBlock:^{
                    [flyMoneySpread1 addSpreadAnimationWithRepeat:self.hassendnum];
                }];
                [NSObject asyncWaitingWithTime:0.3*self.hassendnum completeBlock:^{
                    [showMoneyImage removeFromSuperview];
                }];
//            }
            
            [flyMoney addFallingAnimationWithFromCGPoint:flyMoney.center toPoint:CGPointMake(flyMoney.center.x, self.showTodayEarnings.center.y-10) repeat:self.hassendnum];
            
            [NSObject asyncWaitingWithTime:0.3 * repeatNumber completeBlock:^{
                [self.showTodayEarnings addSplashAnimation];
            }];
            
            NSInteger todisplaynum = (self.unReadMessage == self.unreadnum && self.isfirstopen) ? self.unreadnum:(firstdisplaynum+self.hassendnum);

            [self.showTodayEarnings.getPrivateChatMoneyLab pp_fromNumber:firstdisplaynum toNumber:todisplaynum duration:self.hassendnum*0.4 animationOptions:PPCounterAnimationOptionCurveLinear format:^NSString *(CGFloat currentNumber) {
                return [NSString stringWithFormat:@"%.0f",currentNumber];
                
            } completion:^(CGFloat endNumber) {
                
            }];

            self.isEndAnimation = NO;
            [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"Delay" timeInterval:1+self.hassendnum*0.3+0.1 queue:nil repeats:NO actionOption:AbandonPreviousAction action:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isEndAnimation = YES;
                    self.showTodayEarnings.hidden = YES;
                    self.unreadnum = self.hassendnum+self.unreadnum;
                    self.hasreceive = NO;
                    self.hassendnum = 0;
                    self.isfirstopen = NO;

                    [self.showTodayEarnings addAnimationWithFromCGPoint:CGPointMake(56.5, self.showTodayEarnings.center.y) endPoint:CGPointMake(-41, self.showTodayEarnings.center.y) andWaitTime:0.2 animationKey:@"EndflyMoneyCoin"];
                });
                
            }];
        }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];

//    [self getRechargeInfo];
    [self getCoinBalanceData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [XJRongIMManager.sharedInstance setUpTabbarUnreadNum];
}

// 获取当前么币
- (void)getCoinBalanceData{
    [AskManager GET:API_MY_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            self.currentMcoin = [data[@"mcoin"] integerValue];
            XJUserModel *oldmdel = XJUserAboutManageer.uModel;
            oldmdel.mcoin = self.currentMcoin;
            XJUserAboutManageer.uModel = oldmdel;
        }
    } failure:^(NSError *error) {
        
    }];
}

/*
- (void)presentViewController:(UIViewController *)viewController functionTag:(NSInteger)functionTag {
    NSLog(@"functionTag tagged:%ld", functionTag);
    if ([XJUserAboutManageer isUserBanned]) {
        return;
    }
    switch (functionTag) {
        case 10001:
        {
            [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self selectCamera];
                } else if (buttonIndex == 1) {
                    [self selectAlbum];
                }
            }];
            break;
        }
    }
}

 */
- (void)selectCamera {
    @WeakObj(self);
    if (![XJUtils isAllowCamera]) return;
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [weakself sendImageMessage:image];
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (void)selectAlbum {
    @WeakObj(self);
    if (![XJUtils isAllowPhotoLibrary]) return;
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:4 delegate:nil];
    controller.allowTakePicture = NO; // 在内部显示拍照按钮
    controller.navigationBar.barTintColor = kYellowColor;
    controller.oKButtonTitleColorDisabled = HEXCOLOR(0x000000);
    controller.oKButtonTitleColorNormal = HEXCOLOR(0x000000);
    controller.allowPickingVideo = NO;
    controller.allowTakePicture = NO;
    controller.barItemTextColor = HEXCOLOR(0x000000);
    [self presentViewController:controller animated:YES completion:nil];
    [controller setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"counts = %ld",photos.count);
        if (photos.count<=0) {
            return ;
        }
        [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             [weakself sendImageMessage:obj];
         }];
        
    }];
}

- (void)sendImageMessage:(UIImage *)image {
    RCImageMessage *imageMessage = [RCImageMessage messageWithImage:image];
    [self sendMessage:imageMessage pushContent:nil];
}

- (void)routerEventWithName:(NSInteger)event userInfo:(NSDictionary *)userInfo Cell:(RCMessageBaseCell *)cell {
    if (event == ZZRouterEventTapOrderInfo) {
        id model = [userInfo objectForKey:@"data"];
        if ([model isKindOfClass:[ZZChatOrderInfoModel class]]) {
            ZZChatOrderInfoModel *orderModel = (ZZChatOrderInfoModel *)model;
            if (![orderModel.order_id isEqualToString:@"0"]) {
                if ([orderModel.title isEqualToString:@"申诉中"]) {
                    [self gotoChatServerView];
                }
                else {
                    [self gotoOrderDetail:orderModel.order_id];
                }
            }
            else {
//                [self endEditing];
            }
        }
        else {
            [self notifyOther];
        }
    }
}

- (void)notifyOther {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    [ZZHUD showWithStatus:nil];
    WEAK_SELF()
//    [self.order remindWithOrderId:self.order.id status:self.order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        if (error) {
//            [ZZHUD showErrorWithStatus:error.message];
//        } else {
//            [weakSelf callBack];
//        }
//    }];
}

/**
 客服
 */
- (void)gotoChatServerView {
    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = kCustomerServiceId;
    chatService.title = @"客服";
    chatService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController :chatService animated:YES];
    //以防融云一更新客服聊天中 用户自己的头像又没了
    [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri = XJUserAboutManageer.uModel.avatar;
}

- (void)gotoOrderDetail:(NSString *)orderId {
//    [XJa];
    _isFrom = [XJUserAboutManageer.uModel.uid isEqualToString:self.order.from.uid];
    [self.view endEditing:YES];
//    if (_isFromOrderDetail && [orderId isEqualToString:_order.id]) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    if (_isFrom && _order.to.banStatus) {
        [UIAlertView showWithTitle:@"提示" message:@"该用户已被封禁!" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        }];
        return;
    }
    if (!_isFrom && _order.from.banStatus) {
        [UIAlertView showWithTitle:@"提示" message:@"该用户已被封禁!" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        }];
        return;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZOrderDetailViewController *controller = [[ZZOrderDetailViewController alloc] init];
        controller.orderId = orderId;
        controller.isFromChat = YES;
        [self.navigationController pushViewController:controller animated:YES];
    });
}

#pragma mark lazy
- (XJMsgInputTophintView *)topHintView{
    if (!_topHintView) {
        _topHintView = [[XJMsgInputTophintView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreenWidth, 20)];
    }
    return _topHintView;
}

/**
 今日收益要做动画,从左到右移动
 */
- (ZZPrivateChatShowMoneyView *)showTodayEarnings {
    
    if (!_showTodayEarnings) {
        _showTodayEarnings = [[ZZPrivateChatShowMoneyView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_showTodayEarnings];
    }
    
    return _showTodayEarnings;
}

// 获取今日收益
- (void)fetchTodaysProfits:(NSString *)uid {
    @WeakObj(self);
    [AskManager GET:[NSString stringWithFormat:@"api/user/%@/gettodaychatcount",uid] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            if ([data isKindOfClass: [NSDictionary class]]) {
//                weakself.unreadnum = [data[@"wait_answer"] integerValue];
//                weakself.hassendnum = [data[@"answered"] integerValue];
            }
        }
    } failure:^(NSError *error) {
        
    }];

}

/**
 获取最后一次的订单
 */
- (void)fetchLastOrder {
    NSString *userId = self.targetId;
//    if (!userId) {
//        userId = self.user.uid;
//    }
    [ZZOrder latestWithUser:userId next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            //获取订单
            self.order = [ZZOrder yy_modelWithDictionary:data];
            
            if (self.order.id) {
                [self createStatusView];
            }
        }
    }];
}

- (void)createStatusView {
    if (_topHintView) {
        [_topHintView removeFromSuperview];
        _topHintView = nil;
        
        CGRect fram = self.conversationMessageCollectionView.frame;
        fram.origin.y = fram.origin.y - 20;
        fram.size.height = fram.size.height + 20;
        self.conversationMessageCollectionView.frame = fram;
        return;
    }
 
    _isFrom = [self.order.from.uid isEqualToString:XJUserAboutManageer.uModel.uid];
    
    if (!_statusView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.statusView];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_statusView setData:self.order];
        });
    }
}

#pragma mark - lazyload
- (ZZChatOrderDealView *)dealView {
    WEAK_SELF();
    if (!_dealView) {
        _dealView = [[ZZChatOrderDealView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _dealView.touchAccept = ^{
            [weakSelf accept];
        };
        _dealView.touchRefuse = ^{
            [weakSelf refuse];
        };
    }
    return _dealView;
}


- (ZZChatOrderStatusView *)statusView {
    if (!_statusView) {
        _statusView = [[ZZChatOrderStatusView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 50)];
        WEAK_SELF();
        _statusView.touchStatusView = ^{
            [weakSelf gotoOrderDetail:weakSelf.order.id];
        };
        _statusView.touchMoreBtn = ^{
            [weakSelf showSheet];
        };
        _statusView.touchStatusBtn = ^{
            [weakSelf managerNextCtl];
        };
        _statusView.countDownView.timeOut = ^{
            [weakSelf fetchLastOrder];
        };
        _statusView.countDownView.touchPay = ^{
            [weakSelf pay];
        };
        [_statusView setData:self.order];
        
        self.orderStatusHeight = [_statusView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        _statusView.frame = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, self.orderStatusHeight);
        [self resetStatusHeight];
    }
    return _statusView;
}

- (ZZChatStatusSheetView *)sheetView {
    WEAK_SELF();
    if (!_sheetView) {
        _sheetView = [[ZZChatStatusSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _sheetView.touchCancel = ^{
            [weakSelf cancel];
        };
        _sheetView.touchEdit = ^{
            [weakSelf edit];
        };
        _sheetView.touchRefund = ^{
            [weakSelf wantToRefund];
        };
        _sheetView.touchReject = ^{
            [weakSelf refuse];
        };
        _sheetView.touchRent = ^{
            [weakSelf rentBtnClick];
        };
//        _sheetView.touchAsk = ^{
//            [weakSelf gotoMemedaView];
//        };
        _sheetView.touchDetail = ^{
            [weakSelf loadMessages];
        };
        _sheetView.touchRevokeRefund = ^{
            [weakSelf revokeRefund];
        };
        _sheetView.touchEditRefund = ^{
            [weakSelf editRefund];
        };
    }
    return _sheetView;
}

- (void)resetStatusHeight {
//    self.tableView.height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - self.orderStatusHeight -SafeAreaBottomHeight;
//    self.tableView.top = self.orderStatusHeight;
//    [self scrollToBottom:NO finish:nil];
    
    CGRect fram = self.conversationMessageCollectionView.frame;
    fram.origin.y = fram.origin.y+ self.orderStatusHeight;
    fram.size.height = fram.size.height - self.orderStatusHeight;
    self.conversationMessageCollectionView.frame = fram;
    self.conversationMessageCollectionView.backgroundColor = defaultLineColor;
}

- (void)showSheet {
    [_sheetView removeFromSuperview];
    _sheetView = nil;
    [self.view endEditing:YES];
    [self.view.window addSubview:self.sheetView];
    [self updateDatailType];
    [_sheetView showSheetWithOrder:self.order type:_statusView.detailType];
}

- (void)managerNextCtl {
    [self.view endEditing:YES];
    switch (_statusView.detailType) {
        case OrderDetailTypePending: {
            if (_isFrom) {
                [self edit];
            } else {
                [self showDealView];
            }
            break;
        }
        case OrderDetailTypeMeeting: {
            [self met];
            break;
        }
        case OrderDetailTypeCommenting: {
            if (_isFrom) {
                [self comment];
            } else if(self.order.met && self.order.met.to && self.order.met.from) {
                [self comment];
            }
            break;
        }
        case OrderDetailTypeRefunding: {
            [self gotoOrderDetail:self.order.id];
            break;
        }
        default:
            break;
    }
}

- (void)showDealView {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    [self.view.window addSubview:self.dealView];
    [self.dealView showView];
}

//查看时间轴
- (void)showTimeLine {
    if (!_timeLineView) {
        _timeLineView = [[ZZOrderTimeLineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) order:self.order];
        [self.view.window addSubview:_timeLineView];
    }
    _timeLineView.messageArray = _messageArray;
}

- (void)loadMessages {
    [ZZHUD showWithStatus:@"数据请求中..."];
    [ZZMessage pullOrder:self.order.id next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            NSMutableArray *array = [ZZMessage arrayOfModelsFromDictionaries:data error:nil];
            if (array.count) {
                if (self.messageArray) {
                    [self.messageArray removeAllObjects];
                } else {
                    self.messageArray = [NSMutableArray array];
                }
                [self.messageArray addObjectsFromArray:array];
                
                [self showTimeLine];
            }
        }
    }];
}

- (void)comment {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    ZZOrderCommentViewController *controller = [[ZZOrderCommentViewController alloc] init];
    controller.order = self.order;
    WEAK_SELF()
    controller.successCallBack = ^{
        [weakSelf callBack];
    };
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)met {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    if (_isFrom) {
        [UIAlertView showWithTitle:@"提示" message:@"邀约是否已顺利完成，确定后款项将会支付给对方" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self metRequest];
            }
        }];
    } else {
        [UIAlertView showWithTitle:@"提示" message:@"确认已到达见面地点？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self metRequest];
            }
        }];
    }
}

- (void)metRequest {
    [ZZHUD showWithStatus:@"确认中..."];
    WEAK_SELF()
    [self.order met:XJUserAboutManageer.location status:self.order.status next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD showSuccessWithStatus:@"完成见面!"];
            
            if (_isFrom) {
                [weakSelf reduceOngoingCount];
            }
            [weakSelf callBack];
        }
    }];
}

- (void)editRefund {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    ZZNewOrderRefundOptionsViewController *controller = [[ZZNewOrderRefundOptionsViewController alloc]init];
    controller.order = self.order;
    controller.isFromChat = YES;
    controller.isModify = YES;
    WEAK_SELF()
    controller.callBack = ^(NSString *status) {
        weakSelf.order.status = status;
        [weakSelf callBack];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)revokeRefund {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    NSString *string = @"您撤销退意向金申请后，邀约将会继续进行，资金仍由平台监管。您只有一次撤销申请的机会，确定撤销本次退意向金申请吗？";
    if (self.order.paid_at) {
        string = @"您撤销退款申请后，邀约将会继续进行，资金仍由平台监管。您只有一次撤销申请的机会，确定撤销本次退款申请吗？";
    }
    [UIAlertView showWithTitle:@"提示" message:string cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            WEAK_SELF()
            [ZZOrder revokeRefundOrder:self.order.id status:self.order.status next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                } else {
                    [weakSelf fetchLastOrder];
                }
            }];
        }
    }];
}

- (void)rentBtnClick {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    
    [self.view endEditing:YES];
    if (XJUserAboutManageer.uModel && XJUserAboutManageer.uModel.avatarStatus == 0) {
        [UIAlertView showWithTitle:@"提示" message:@"本人头像不是自己的照片，请先去修改" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去修改"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                XJEditMyInfoVC *controller = [[XJEditMyInfoVC alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }];
    } else {
        ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
        if (self.order.id) {
            controller.uid = _isFrom ? self.order.to.uid:self.order.from.uid;
        } else {
            controller.user = self.user;
        }
        controller.fromChat = YES;
        controller.hidesBottomBarWhenPushed = YES;
        WEAK_SELF()
        controller.callBack = ^{
            [weakSelf fetchLastOrder];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
}


//申请退款
- (void)wantToRefund {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }

    ZZNewOrderRefundOptionsViewController *vc = [[ZZNewOrderRefundOptionsViewController alloc]init];
    vc.order = self.order;
    vc.isFromChat = YES;
    WEAK_SELF()
    vc.callBack = ^(NSString *status) {
        weakSelf.order.status = status;
        [weakSelf callBack];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 编辑约会
- (void)edit {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
    controller.isEdit = YES;
    controller.order = self.order;
    XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pay {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    ZZPayViewController *vc = [[ZZPayViewController alloc] init];
    vc.order = self.order;
    WEAK_SELF()
    vc.didPay = ^(){
        [weakSelf callBack];
    };
    vc.type = PayTypeOrder;
    [self.navigationController pushViewController:vc animated:YES];
}

// 取消
- (void)cancel {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    if (_isFrom && _statusView.detailType == OrderDetailTypePaying) {
        ZZNewOrderRefundOptionsViewController *controller = [[ZZNewOrderRefundOptionsViewController alloc]init];
        controller.order = self.order;
        controller.isFromChat = YES;
        [self.navigationController pushViewController:controller animated:YES];
        WEAK_SELF()
        controller.callBack = ^(NSString *status) {
            weakSelf.order.status = status;
            [weakSelf callBack];
            [weakSelf reduceOngoingCount];
        };

    } else {
        ZZOrderTalentShowViewController *vc = [[ZZOrderTalentShowViewController alloc] init];
        vc.order = self.order;
        vc.uid = self.targetId;
        vc.isFrom = _isFrom;
        WEAK_SELF()
        vc.callBack = ^(NSString *status) {
            weakSelf.order.status = status;
            [weakSelf callBack];
            [weakSelf reduceOngoingCount];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)callBack {
    [_statusView setData:self.order];
    if (_statusChange) {
        _statusChange();
    }
}

- (void)updateDatailType {
    if ([self.order.status isEqualToString:@"pending"]) {//等待接受
        _statusView.detailType = OrderDetailTypePending;
    }
    if ([self.order.status isEqualToString:@"cancel"]) {//取消
        _statusView.detailType = OrderDetailTypeCancel;
    }
    if ([self.order.status isEqualToString:@"refused"]) {//拒绝
        _statusView.detailType = OrderDetailTypeRefused;
    }
    if ([self.order.status isEqualToString:@"paying"]) {//待付款
        _statusView.detailType = OrderDetailTypePaying;
    }
    if ([self.order.status isEqualToString:@"meeting"]) {//见面中
        _statusView.detailType = OrderDetailTypeMeeting;
    }
    if ([self.order.status isEqualToString:@"commenting"]) {//待评论
        _statusView.detailType = OrderDetailTypeCommenting;
    }
    if ([self.order.status isEqualToString:@"commented"]) {//已评价
        _statusView.detailType = OrderDetailTypeCommented;
    }
    if ([self.order.status isEqualToString:@"appealing"]) {//申诉中
        _statusView.detailType = OrderDetailTypeAppealing;
    }
    if ([self.order.status isEqualToString:@"refunding"]) {//申请退款
        _statusView.detailType = OrderDetailTypeRefunding;
    }
    if ([self.order.status isEqualToString:@"refundHanding"]) {//退款处理中
        _statusView.detailType = OrderDetailTypeRefundHanding;
    }
    if ([self.order.status isEqualToString:@"refusedRefund"]) {//拒绝退款
        _statusView.detailType = OrderDetailTypeRefusedRefund;
    }
    if ([self.order.status isEqualToString:@"refunded"]) {//已经退款
        _statusView.detailType = OrderDetailTypeRefunded;
    }
}

- (void)accept {
    [ZZHUD showWithStatus:nil];
    WEAK_SELF()
    [self.order accept:self.order.status next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            [weakSelf callBack];
        }
    }];
}

// 拒绝
- (void)refuse {
    if (XJUserAboutManageer.isUserBanned) {
        return;
    }
    ZZOrderTalentShowViewController *vc = [[ZZOrderTalentShowViewController alloc] init];
    if ([XJUserAboutManageer.uModel.uid isEqualToString:self.order.from.uid]) {
        vc.uid = self.order.to.uid;
    } else {
        vc.uid = self.order.from.uid;
    }
    vc.order = self.order;
    vc.isRefusedInvitation = YES;
    vc.isFrom = NO;
    WEAK_SELF()
    vc.callBack = ^(NSString *status) {
        weakSelf.order.status = status;
        [weakSelf callBack];
        [weakSelf reduceOngoingCount];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reduceOngoingCount {
    if (XJUserAboutManageer.unreadModel.order_ongoing_count > 0) {
        XJUserAboutManageer.unreadModel.order_ongoing_count--;
    }
//    [[ZZTabBarViewController sharedInstance] managerAppBadge];
}

@end
