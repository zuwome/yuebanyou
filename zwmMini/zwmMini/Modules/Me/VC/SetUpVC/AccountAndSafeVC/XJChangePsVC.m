//
//  XJChangePsVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJChangePsVC.h"
#import "XJChangePsView.h"
#import "XJForgetPasswordVC.h"
@interface XJChangePsVC ()<XJChangePsViewDelegate>

@property(nonatomic,strong) UIButton *forgetBtn;
@property(nonatomic,copy) NSString *psOldStr;
@property(nonatomic,copy) NSString *psNewStr;


@end

@implementation XJChangePsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self creatUI];
}

- (void)creatUI{
    
    [self showNavRightButton:@"保存" action:@selector(rightAction) image:nil imageOn:nil];
    XJChangePsView *passV = [[XJChangePsView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 110)];
    [self.view addSubview:passV];
    passV.delegate = self;
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(passV.mas_bottom).offset(20);
    }];
    
}

//旧密码
- (void)oldPassText:(NSString *)text{
    
    self.psOldStr = text;
}
//新密码
- (void)newPassText:(NSString *)text{
    
    self.psNewStr = text;
}

//保存
- (void)rightAction{
    
    if (NULLString(self.psOldStr)) {
        [MBManager showBriefAlert:@"旧密码不能为空"];
        return;
    }
    if (self.psNewStr.length < 6) {
        
        [MBManager showBriefAlert:@"密码至少为6位字符"];
        return;
    }
    if (self.psNewStr.length > 16) {
        [MBManager showBriefAlert:@"密码最多为16位字符"];
        return;
    }
    if (![XJUtils isThePasswordNotTooSimpleWithPasswordString:self.psNewStr]) {
        [MBManager showBriefAlert:@"密码过于简单 请尝试字母、数字组合"];
        return ;
    }
    [AskManager POST:API_CHANGE_PASSWORD_POST dict:@{@"op":self.psOldStr,@"np":self.psNewStr}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            [MBManager showBriefAlert:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(NSError *error) {

        
    }];
    
}

//忘记密码
- (void)forgetBtnAction{
    
    XJForgetPasswordVC *forgetPwVC = [XJForgetPasswordVC new];
    [self.navigationController pushViewController:forgetPwVC animated:YES];
}

- (UIButton *)forgetBtn{
    if (!_forgetBtn) {
        _forgetBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.view backColor:defaultClearColor nomalTitle:@"忘记密码 >" titleColor:defaultBlack titleFont:defaultFont(15) nomalImageName:nil selectImageName:nil target:self action:@selector(forgetBtnAction)];
    }
    return _forgetBtn;
    
    
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
