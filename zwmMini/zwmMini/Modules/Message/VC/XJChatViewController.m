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

static NSString *PrivateChatPay = @"PrivateChatPay";
static NSString *RCMTextCell = @"rcmtextcell";

@interface XJChatViewController () <RCChatSessionInputBarControlDelegate>
@property(nonatomic,assign) NSInteger currentMcoin;//当前m币
@property(nonatomic,strong) XJMsgInputTophintView *topHintView;
@property(nonatomic,assign) BOOL isBlack;

@property (nonatomic, strong) ZZPrivateChatShowMoneyView *showTodayEarnings;
@property (nonatomic,assign) BOOL isEndAnimation;//动画是否结束了

@property(nonatomic,assign) BOOL hasreceive;
@property(nonatomic,assign) BOOL isfirstopen;


@property(nonatomic,assign) NSInteger unreadnum;
@property(nonatomic,assign) NSInteger hassendnum;



@end

@implementation XJChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableUnreadMessageIcon = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self fetchBalance];
    
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    [self registerClass:[XJRCMTextsCollectionViewCell class] forMessageClass:[RCTextMessage class]];
    
    
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
    
    if (self.isNeedCharge) {
        // 需要付费
        
        // 么币不足去充值
        if (self.currentMcoin < [XJUserAboutManageer.priceConfig.per_chat_cost_mcoin integerValue]) {
            [self gotoPayVC:[XJUserAboutManageer.priceConfig.per_chat_cost_mcoin integerValue]];
            return;
        }

    extraDic = isneedCheck ? @{@"payChat":PrivateChatPay,@"check":@(isneedCheck)}.mutableCopy:@{@"payChat":PrivateChatPay,@"check":@(isneedCheck)}.mutableCopy;
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

@end
