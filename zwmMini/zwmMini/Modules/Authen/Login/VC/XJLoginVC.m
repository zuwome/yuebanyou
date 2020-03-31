//
//  XJLoginVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJLoginVC.h"
#import "XJLoginView.h"
#import "XJSelectAreaCodeVC.h"
#import "XJRegistVC.h"
#import "XJMessageLoginVC.h"
#import "XJForgetPasswordVC.h"
#import "XJTabBarVC.h"
#import "XJUsePrivaProtocalVC.h"
#import "ZZProtocalChooseView.h"
#import "XJNaviVC.h"

@interface XJLoginVC()<XJLoginViewDelegate>

@property(nonatomic,strong) XJLoginView *loginView;
@property(nonatomic,copy) NSString *selectCode;
@property(nonatomic,copy) NSString *phoneNum;
@property(nonatomic,copy) NSString *password;
@property (nonatomic, assign) BOOL isAgreed;

@end

@implementation XJLoginVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"登录";
    [self showNavRightButton:@"注册" action:@selector(registAction) image:nil imageOn:nil];
//    [self showBack:@selector(backAction)];
    [self.view addSubview:self.loginView];
    self.phoneNum = @"";
    self.password = @"";
    self.selectCode = @"+86";
    
    
}

- (void)registAction{
    NSLog(@"注册");
    XJRegistVC *vc = [XJRegistVC new];
    vc.account = _loginView.phoneTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

//用户使用和
- (void)clickUserProtocal{
    XJUsePrivaProtocalVC *vc =[XJUsePrivaProtocalVC new];
    vc.isPrivate = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

// 隐私协议
- (void)clickUserPrivateProtocal{
    XJUsePrivaProtocalVC *vc =[XJUsePrivaProtocalVC new];
    vc.isPrivate = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)agreeTheProtocol:(BOOL)isAgreed {
    _isAgreed = isAgreed;
}

#pragma mark loginViewdelegate
// 更换区号
- (void)selectAreaCode{
    NSLog(@"更换区号");
    XJSelectAreaCodeVC *selectVC = [XJSelectAreaCodeVC new];
    
    selectVC.selectedCode = ^(NSString * _Nonnull code) {
        self.selectCode = code;
        self.loginView.areaCodeLb.text = code;
    };
    
    XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:selectVC] ;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

// 手机号
- (void)phoneText:(NSString *)phone{
    self.phoneNum = phone;
}

// 密码
- (void)passwordText:(NSString *)psword{
    self.password = psword;
    
    
}
// 登录
- (void)nomalLogin{
    if (NULLString(self.phoneNum)) {
        [MBManager showBriefAlert:@"手机号不能为空"];
        return;
    }
    
    if (self.password.length == 0) {
        [MBManager showBriefAlert:@"请输入密码"];
        return;
    }
    
    if (!_loginView.protocolView.isSelected) {
        [MBManager showBriefAlert:@"请同意《用户使用和隐私协议》"];
        return;
    }
    
    [MBManager showWaitingWithTitle:@"登录中"];
    NSMutableDictionary *param = @{
                                   @"phone":self.phoneNum,
                                   @"password":self.password,
                                   @"country_code":self.selectCode
                                   }.mutableCopy;
    @WeakObj(self);
    [AskManager POST:API_LOGIN_POST dict:param succeed:^(id data, XJRequestError *rError) {
        @StrongObj(self);
        [MBManager hideAlert];

        if (!rError) {
            
            XJUserAboutManageer.access_token = data[@"access_token"];
            XJUserAboutManageer.qiniuUploadToken = data[@"upload_token"];
            XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data[@"user"]];
            XJUserAboutManageer.uModel = userModel;
            XJUserAboutManageer.isLogin = YES;
            [self getRongToken];
            [MBManager showBriefAlert:@"登录成功"];
            
            //登录成功开启内购漏单检测
//            [ZZPayHelper startManager];
//            [ZZActivityUrlNetManager requestHtmlActivityUrlDetailInfo];//h5活动页
            [[NSNotificationCenter defaultCenter] postNotificationName:loginISSuccess object:self];

            ([UIApplication sharedApplication].delegate).window.rootViewController = [[XJTabBarVC alloc] init];
//            self.tabBarController.selectedIndex = 0;
//            [self.navigationController popToRootViewControllerAnimated:YES];
//
      
            
        }else{
            switch (rError.code) {
                case 4044:
                    {
                        [self showAlerVCtitle:@"提示" message:@"该手机尚未注册,请点击立即注册" sureTitle:@"立即注册" cancelTitle:@"取消" sureBlcok:^{

                        XJRegistVC *vc = [XJRegistVC new];
                        vc.account = self.loginView.phoneTF.text;
                        [self.navigationController pushViewController:vc animated:YES];


                        }  cancelBlock:^{
                            
                        }];
                       
                    }
                    break;
                case 4045:
                {
                    [self showAlerVCtitle:@"提示" message:@"密码错误,请选择验证码登录或重新输入" sureTitle:@"验证码登录" cancelTitle:@"重新输入" sureBlcok:^{
                        
                        XJMessageLoginVC *vc = [[XJMessageLoginVC alloc] initWithMobile:self.loginView.phoneTF.text areaCode:self.loginView.areaCodeLb.text];
//                        vc.areaCode = self.loginView.areaCodeLb.text;
//                        vc.inputMobile = self.loginView.phoneTF.text;
                        [self.navigationController pushViewController:vc animated:YES];

                        
                    } cancelBlock:^{
                        
                    }];
                    
                }
                    break;
                case 8000:
                {
                    [UIAlertController presentAlertControllerWithTitle:@"提示" message:rError.message doneTitle:@"知道了" cancelTitle:nil showViewController:self completeBlock:nil];
                }
                    break;
                    
                default:
                    break;
            }
          
            
        }
        
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];
        
    }];
    
    

}

//获取融云token
- (void)getRongToken{
    
    [AskManager GET:API_GET_RONGIM_TOKEN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJUserAboutManageer.rongTonek = data[@"token"];
            [[XJRongIMManager sharedInstance] connectRongIM];
        }
    } failure:^(NSError *error) {
        NSLog(@"fetch rongyun token failed: %@", error);
    }];
    
}
//验证码登录
- (void)msgLogin{
    
    NSLog(@"验证码登录");
//    [self.navigationController pushViewController:[XJMessageLoginVC new] animated:YES];
    XJMessageLoginVC *vc = [[XJMessageLoginVC alloc] initWithMobile:self.loginView.phoneTF.text areaCode:self.loginView.areaCodeLb.text];
//    vc.areaCode = self.loginView.areaCodeLb.text;
//    vc.inputMobile = self.loginView.phoneTF.text;
    [self.navigationController pushViewController:vc animated:YES];

}
//忘记密码
- (void)forgetPassword{
    NSLog(@"忘记密码");
    XJForgetPasswordVC *forgetPwVC = [XJForgetPasswordVC new];
    [self.navigationController pushViewController:forgetPwVC animated:YES];


}


#pragma mark lazy
- (XJLoginView *)loginView{

    if (!_loginView) {
        _loginView = [[XJLoginView alloc] initWithFrame:self.view.frame];
        _loginView.delegate = self;
        _loginView.ismsgLogin = NO;
    }
    return _loginView;
}
@end
