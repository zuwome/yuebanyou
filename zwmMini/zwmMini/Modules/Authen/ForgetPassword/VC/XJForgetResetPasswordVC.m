//
//  XJForgetResetPasswordVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJForgetResetPasswordVC.h"
#import "XJRestPasswordView.h"
#import "XJSelectAreaCodeVC.h"
@interface XJForgetResetPasswordVC ()<XJRestPasswordDelegate>

@property(nonatomic,strong) XJRestPasswordView *resetView;
@property(nonatomic,copy) NSString *passwordnew;
@property(nonatomic,copy) NSString *msgCode;
@property (nonatomic, strong) NSTimer *messsageTimer;
@property (nonatomic, assign) NSInteger authCodeTime;
@property(nonatomic,strong) UIButton *sendMsgBtn;

@end

@implementation XJForgetResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"重置密码";
    self.msgCode = @"";
    self.passwordnew = @"";
    [self creatUI];
    
}


- (void)creatUI{
    
    [self.view addSubview:self.resetView];
    [self.resetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    
}



#pragma XJResetViewDelegate

//验证码
- (void)msgText:(NSString *)msgcode{
    
    self.msgCode = msgcode;
    NSLog(@"msgcode = %@",self.msgCode);
    
}
//密码
- (void)passwordnText:(NSString *)newpsword{
    
    self.passwordnew = newpsword;
    NSLog(@"newps = %@",self.passwordnew);

}

//发送验证码

- (void)senLoginMsg:(UIButton *)btn{
    

    self.sendMsgBtn = btn;
    
    [MBManager showLoading];
    @WeakObj(self);
    [AskManager POST:API_SENMESSAGE_REGIST_POST dict:@{@"phone":self.phone,@"country_code":self.areaCode}.mutableCopy succeed:^(id data, XJRequestError *rError) {
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


//重置密码
- (void)resetPassword{
    
    [self checkPhoneAndPassword];
    [MBManager showWaitingWithTitle:@"重置密码中"];
    NSMutableDictionary *para = @{@"phone":self.phone,
                                  @"password":self.passwordnew,
                                  @"code":self.msgCode,
                                  @"country_code":self.areaCode}.mutableCopy ;
    
    [AskManager POST:API_RESET_PASSWORD_POST dict:para succeed:^(id data, XJRequestError *rError) {
                                                        
                                                        
        if (!rError) {
            
            [MBManager showBriefAlert:@"密码修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            
            
        }
        
        
        [MBManager hideAlert];
                                                      
    } failure:^(NSError *error) {
        
        
        [MBManager hideAlert];

        
    }];
    
}
//判断验证码和密码

- (void)checkPhoneAndPassword{
    
   
    if (self.msgCode.length == 0) {
        
        [MBManager showBriefAlert:@"请输入验证码"];
        return;
    }
    if (self.passwordnew.length < 6) {
        
        [MBManager showBriefAlert:@"密码至少为6位字符"];
        return;
    }
    if (self.passwordnew.length > 16) {
        [MBManager showBriefAlert:@"密码最多为16位字符"];
        return;
    }
    if (![XJUtils isThePasswordNotTooSimpleWithPasswordString:self.passwordnew]) {
        [MBManager showBriefAlert:@"密码过于简单 请尝试字母、数字组合"];
        return ;
    }
    
}





- (void)dealloc{
    if (self.messsageTimer) {
        [self.messsageTimer invalidate];
        self.messsageTimer = nil;
    }
}





#pragma mark lazy
- (XJRestPasswordView *)resetView{
    
    if (!_resetView) {
        _resetView = [[XJRestPasswordView alloc] initWithFrame:CGRectZero];
        _resetView.delegate = self;
    }
    return _resetView;
    
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
