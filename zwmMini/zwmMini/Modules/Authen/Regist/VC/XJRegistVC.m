//
//  XJRegistVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRegistVC.h"
#import "XJRegistView.h"
#import "XJSelectAreaCodeVC.h"
#import "XJSetUpPsWordVC.h"
#import "XJUsePrivaProtocalVC.h"
#import "XJTabBarVC.h"
#import "XJNaviVC.h"

@interface XJRegistVC ()<XJRegistViewDelegate>
@property(nonatomic,strong) XJRegistView *registView;
@property(nonatomic,copy) NSString *selectCode;
@property(nonatomic,copy) NSString *phoneNum;
@property(nonatomic,copy) NSString *msgCode;
@property (nonatomic, assign) BOOL isAgreed;

@property (nonatomic, strong) NSTimer *messsageTimer;
@property (nonatomic, assign) NSInteger authCodeTime;
@property(nonatomic,strong) UIButton *sendMsgBtn;

@end

@implementation XJRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self.view addSubview:self.registView];
    self.selectCode = @"+86";
    self.msgCode = @"";
    self.phoneNum = _account;
    self.isAgreed = NO;
    if (_phoneNum.length != 0) {
        _registView.phoneTF.text = self.phoneNum;
    }
}


- (void)agreeTheProtocol:(BOOL)isAgreed {
    _isAgreed = isAgreed;
}

//更换区号
- (void)selectAreaCode{
    
    NSLog(@"更换区号");
    XJSelectAreaCodeVC *selectVC = [XJSelectAreaCodeVC new];
    
    selectVC.selectedCode = ^(NSString * _Nonnull code) {
        
        self.selectCode = code;
        self.registView.areaCodeLb.text = code;
        
    };
    XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:selectVC] ;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

// 发送验证码
- (void)senLoginMsg:(UIButton *)btn{
    
    NSLog(@"发送验证码");
    if (NULLString(self.phoneNum)) {
        [MBManager showBriefAlert:@"手机号不能为空"];
        return;
    }
   
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
//手机号
- (void)phoneText:(NSString *)phoneNum{
    
    self.phoneNum  = phoneNum;
    
;
}
//验证码
- (void)msgcodText:(NSString *)msg{
    
    self.msgCode = msg;
}
//注册
- (void)nomalRegist{
    
    NSLog(@"下一步");
    if (NULLString(self.phoneNum)) {
        [MBManager showBriefAlert:@"手机号不能为空"];
        return;
    }
//    if (![XJUtils isPhoneNumber:self.phoneNum]) {
//        
//        [MBManager showBriefAlert:@"手机号格式错误"];
//        return;
//    }
//    

    if (NULLString(self.msgCode)) {
        [MBManager showBriefAlert:@"验证码不能为空"];
        return;
    }
    
    if (!_isAgreed) {
        [MBManager showBriefAlert:@"请同意《用户使用和隐私协议》"];
        return;
    }
    
    [MBManager showWaitingWithTitle:@"注册中..."];
    [AskManager POST:API_REGIST_NEXT_POST dict:@{@"phone":self.phoneNum,@"code":self.msgCode,@"country_code":self.selectCode}.mutableCopy succeed:^(id data, XJRequestError *rError) {

        if (!rError) {
            
//            NSLog(@"%@",data);
            
            NSArray *allkeys = [data allKeys];
            
            //access_token为空未注册
            if (![allkeys containsObject:@"access_token"]) {
                
                //获取骑牛uploadtoken
                XJUserAboutManageer.qiniuUploadToken = data[@"upload_token"];
                XJSetUpPsWordVC *psVC = [XJSetUpPsWordVC new];
                NSDictionary *praDic = @{@"phone":self.phoneNum,@"country_code":self.selectCode,@"code":self.msgCode};
                psVC.paraDic = praDic;
                
                [self.navigationController pushViewController:psVC animated:YES];
                
                
                //已注册直接登录
            }else
            {
                
                XJUserAboutManageer.access_token = data[@"access_token"];
                XJUserAboutManageer.qiniuUploadToken = data[@"upload_token"];
                XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data[@"user"]];
                XJUserAboutManageer.uModel = userModel;
                XJUserAboutManageer.isLogin = YES;

                [MBManager showBriefAlert:@"该账号已注册直接登录"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:loginISSuccess object:self];
                
                ([UIApplication sharedApplication].delegate).window.rootViewController = [[XJTabBarVC alloc] init];
                
            }
      
            
        
            
        }else{
            

        }
        
        [MBManager hideAlert];
        
        
    } failure:^(NSError *error) {
        [MBManager hideAlert];
        
        
    }];
}

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



#pragma mark lazy
- (XJRegistView *)registView{
    
    if (!_registView) {
        _registView = [[XJRegistView alloc] initWithFrame:self.view.frame];
        _registView.delegate = self;
        _registView.isLogin = NO;
    }
    return _registView;
}
- (void)dealloc{
    if (self.messsageTimer) {
        [self.messsageTimer invalidate];
        self.messsageTimer = nil;
    }
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
