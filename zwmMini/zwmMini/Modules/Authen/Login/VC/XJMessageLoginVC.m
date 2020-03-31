//
//  XJMessageLoginVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/16.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMessageLoginVC.h"
#import "XJLoginView.h"
#import "XJSelectAreaCodeVC.h"
#import "XJRegistVC.h"
#import "XJTabBarVC.h"
#import "XJUsePrivaProtocalVC.h"
#import "ZZProtocalChooseView.h"
#import "XJNaviVC.h"
@interface XJMessageLoginVC()<XJLoginViewDelegate>

@property(nonatomic,strong) XJLoginView *loginView;
@property(nonatomic,copy) NSString *selectCode;
@property (nonatomic, strong) NSTimer *messsageTimer;
@property (nonatomic, assign) NSInteger authCodeTime;
@property(nonatomic,strong) UIButton *sendMsgBtn;
@property(nonatomic,copy) NSString *phoneNum;
@property(nonatomic,copy) NSString *msgCode;
@property (nonatomic, assign) BOOL isAgreed;

@end
@implementation XJMessageLoginVC

- (instancetype)initWithMobile:(NSString *)mobile areaCode:(NSString *)areaCode {
    self = [super init];
    if (self) {
        _selectCode = !NULLString(areaCode) ? areaCode : @"+86";
        _phoneNum = !NULLString(mobile) ? mobile : @"";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"验证码登录";
    [self.view addSubview:self.loginView];
    self.msgCode = @"";
    
}

#pragma mark loginViewdelegate
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

//手机号
- (void)phoneText:(NSString *)phone{
    self.phoneNum = phone;
    
}
//验证码
- (void)passwordText:(NSString *)psword{
    self.msgCode = psword;
    
    
}
//更换区号
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

//登录
- (void)nomalLogin{
    
    NSLog(@"登录");
    if (![self checkPhoneAndPassword]) {
        return;
    }
    
    if (!_loginView.protocolView.isSelected) {
        [MBManager showBriefAlert:@"请同意《用户使用和隐私协议》"];
        return;
    }

    
    @WeakObj(self);
    [AskManager POST:API_REGIST_NEXT_POST dict:@{@"phone":self.phoneNum,@"code":self.msgCode,@"country_code":self.selectCode}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        @StrongObj(self);
        if (!rError) {
            
            
            //用户不存在去注册额
            if (NULLString(data[@"access_token"])) {
                
                [self showAlerVCtitle:@"提示" message:@"该用户尚未注册" sureTitle:@"去注册" cancelTitle:nil sureBlcok:^{
                    [self.navigationController pushViewController:[XJRegistVC new] animated:YES];

                } cancelBlock:nil];

                
            }else{

                XJUserAboutManageer.access_token = data[@"access_token"];
                XJUserAboutManageer.qiniuUploadToken = data[@"upload_token"];
                XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data[@"user"]];
                XJUserAboutManageer.uModel = userModel;
                XJUserAboutManageer.isLogin = YES;
                [self getRongToken];
                [MBManager showBriefAlert:@"登录成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:loginISSuccess object:self];
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];

                ([UIApplication sharedApplication].delegate).window.rootViewController = [[XJTabBarVC alloc] init];

                
                ///验证码登录添加人脸识别 -  只有设备首次登录会
//                NSNumber* isneedfacetest = data[@"isneedfacetest"];
//                if ([isneedfacetest integerValue]==1) {
//                    //跳到人脸识别
//
//
//
//                }else{
                
                    
//                    self.tabBarController.selectedIndex = 0;
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
                
            }
            
         
         
         
            
        }else{
            
            if (rError.code == 8000) {
                
                    [UIAlertController presentAlertControllerWithTitle:@"提示" message:rError.message doneTitle:@"知道了" cancelTitle:nil showViewController:self completeBlock:nil];
                    return ;
  
            }
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        
        
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
        
    }];
    
}
//判断手机号和验证码

- (BOOL)checkPhoneAndPassword{
    
    if (NULLString(self.phoneNum)) {
        [MBManager showBriefAlert:@"手机号不能为空"];
        return NO;
    }
//    if (![XJUtils isPhoneNumber:self.phoneNum]) {
//
//        [MBManager showBriefAlert:@"手机号格式错误"];
//        return;
//    }
    if (self.msgCode.length == 0) {
        
        [MBManager showBriefAlert:@"请输入验证码"];
        return NO;
    }
    return YES;
    
}

//发送验证码
- (void)senLoginMsg:(UIButton *)btn{
    
    
    if (NULLString(self.phoneNum)) {
        [MBManager showBriefAlert:@"手机号不能为空"];
        return;
    }
//    if (![XJUtils isPhoneNumber:self.phoneNum]) {
//        
//        [MBManager showBriefAlert:@"手机号格式错误"];
//        return;
//    }
    
    
    self.sendMsgBtn = btn;
    
    
    [MBManager showLoading];
    @WeakObj(self);
    [AskManager specailPOST:API_SENMESSAGE_REGIST_POST dict:@{@"phone":self.phoneNum,@"country_code":self.selectCode}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        @StrongObj(self);
        if (!rError) {
            [MBManager showBriefAlert:@"短信已发送"];
            if (self.messsageTimer == nil) {
                
                self.authCodeTime = 60;
                self.messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimeCountDown) userInfo:nil repeats:YES];
            }
        }else{
            
            
            
        }
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];
        
        
    }];
}

- (void)actionTimeCountDown{
    
    [self.sendMsgBtn setTitle:[NSString stringWithFormat:@"%lds", self.authCodeTime] forState:UIControlStateNormal];
    self.sendMsgBtn.userInteractionEnabled = NO;
    if (self.authCodeTime <= 0) {
        [self.sendMsgBtn setTitle:@"发送" forState:UIControlStateNormal];
        self.sendMsgBtn.userInteractionEnabled = YES;
        [self.messsageTimer invalidate];
        self.messsageTimer = nil;
        self.authCodeTime = 60;
    }
    self.authCodeTime -= 1;
    
}


#pragma mark lazy
- (XJLoginView *)loginView{
    
    if (!_loginView) {
        _loginView = [[XJLoginView alloc] initWithFrame:self.view.frame];
        _loginView.delegate = self;
        _loginView.ismsgLogin = YES;
        _loginView.phoneTF.text = _phoneNum;
        _loginView.areaCodeLb.text = _selectCode;
    }
    return _loginView;
}



- (void)dealloc{
    if (self.messsageTimer) {
        [self.messsageTimer invalidate];
        self.messsageTimer = nil;
    }
}
@end
