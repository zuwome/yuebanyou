//
//  XJWithDrawVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJWithDrawVC.h"
#import "XJWithDrawView.h"
#import "XJWithDrawRecordVC.h"
#import "XJWithDrawProtocalVC.h"
#import <UMShare/UMShare.h>
#import "XJMyWalletVC.h"


@interface XJWithDrawVC ()<XJWIthDarwViewDelegate>

@property(nonatomic,strong) XJWithDrawView *withDrawView;
@property(nonatomic,copy) NSString *postMoney;


@end

@implementation XJWithDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
//    [self showNavRightButton:@"提现记录" action:@selector(rightAction) image:nil imageOn:nil];
    [self.view addSubview:self.withDrawView];
    self.withDrawView.coinModel = self.mycoinModel;
}

- (void)rightAction{
    
    [self.navigationController pushViewController:[XJWithDrawRecordVC new] animated:YES];
    
}

- (void)sureWithDrawMoney:(NSString *)money{
    NSInteger drawMoney = [money integerValue];
    if (drawMoney < 50 ) {
        [MBManager showBriefAlert:@"提现金额最低50元/笔"];
        return;
    }
    if (drawMoney > 2000 ) {
        [MBManager showBriefAlert:@"提现金额最高2000元/笔"];
        return;
    }

    self.postMoney = money;
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];


    
    NSLog(@"money = %@",money);
}


- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
            [MBManager showBriefAlert:@"授权失败"];
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            NSMutableDictionary *pdic = @{
                                          @"channel":@"wx",
                                          @"amount":self.postMoney,
                                          @"recipient":resp.openid
                                          }.mutableCopy;
            [AskManager POST:API_WITHDRAW_POST dict:pdic succeed:^(id data, XJRequestError *rError) {
                
                if (!rError) {
                    
                    [self showAlerVCtitle:@"提示" message:@"您的提现申请已提交，请等待审核，预计1-2日到账。" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                        
                        for (UIViewController* vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[XJMyWalletVC class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                                break;
                            }};
                        
                        
                    } cancelBlock:^{
                        
                    }];
                    
                }else{
                    
                    
                }
                
            } failure:^(NSError *error) {
                
            }];
           
            
            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat unionid: %@", resp.unionId);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
//            // 用户信息
//            NSLog(@"Wechat name: %@", resp.name);
//            NSLog(@"Wechat iconurl: %@", resp.iconurl);
//            NSLog(@"Wechat gender: %@", resp.unionGender);
//            // 第三方平台SDK源数据
//            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            
        }
    }];
}

- (void)clickWithDarwProtocal{
    
    [self.navigationController pushViewController:[XJWithDrawProtocalVC new] animated:YES];


}

- (XJWithDrawView *)withDrawView{
    
    if (!_withDrawView) {
        
        _withDrawView = [[XJWithDrawView alloc] initWithFrame:self.view.frame];
        _withDrawView.delegate = self;

    }
    return _withDrawView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
