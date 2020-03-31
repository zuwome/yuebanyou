//
//  XJSetUpPsWordVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/16.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSetUpPsWordVC.h"
#import "XJSelectGenderVC.h"
@interface XJSetUpPsWordVC ()

@property(nonatomic,strong) UILabel *pstitleLb;
@property(nonatomic,strong) UITextField *pswordTF;
@property(nonatomic,strong) UIView *gradienView;
@property(nonatomic,strong) UIButton *nextBtn;



@end

@implementation XJSetUpPsWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置密码";
//    self.view.backgroundColor = defaultWhite;
    
    [self creatUI];
}



- (void)creatUI{
    
    
    UIView *whitView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
    [whitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(30);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(60);
    }];
    
    [self.pstitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(whitView);
        make.left.equalTo(whitView).offset(20);
        make.width.mas_equalTo(50);
    }];
    
    [self.pswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pstitleLb.mas_right);
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.pstitleLb);
    }];
    
    [self.gradienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.pswordTF.mas_bottom).offset(103);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(60);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gradienView);
    }];
}





//下一步
- (void)nextAction{
    
    NSLog(@"下一步");
    if (self.pswordTF.text.length < 6) {

        [MBManager showBriefAlert:@"密码至少为6位字符"];
        return;
    }
    if (self.pswordTF.text.length > 16) {
        [MBManager showBriefAlert:@"密码最多为16位字符"];
        return;
    }
    if (![XJUtils isThePasswordNotTooSimpleWithPasswordString:self.pswordTF.text]) {
        [MBManager showBriefAlert:@"密码过于简单 请尝试字母、数字组合"];
        return ;
    }
    
    XJSelectGenderVC *seletgenderVC = [XJSelectGenderVC new];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.paraDic];
    dic[@"password"] = self.pswordTF.text;
    seletgenderVC.praDic = (NSDictionary *)dic;
//    NSLog(@"%@",XJUserAboutManageer.qiniuUploadToken);
    //选择性别
    [self.navigationController pushViewController:seletgenderVC animated:YES];
}

#pragma mark
- (UILabel *)pstitleLb{
    
    if (!_pstitleLb) {
        
        _pstitleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultBlack text:@"密码" font:defaultFont(17) textInCenter:NO];
        
    }
    return _pstitleLb;
    
}
- (UITextField *)pswordTF{
    if (!_pswordTF) {
        
        _pswordTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self.view textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"6-16字母和数字组合" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _pswordTF.secureTextEntry = YES;
    }
    return _pswordTF;
    
}
- (UIView *)gradienView{
    
    if (!_gradienView) {
        
        _gradienView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 60)];
        [_gradienView.layer addSublayer:gradientLayer];
        _gradienView.layer.cornerRadius = 30;
        _gradienView.layer.masksToBounds = YES;
    }
    return _gradienView;
}
- (UIButton *)nextBtn{
    
    if (!_nextBtn) {
        
        _nextBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.gradienView backColor:defaultClearColor nomalTitle:@"下一步" titleColor:defaultWhite titleFont:defaultFont(19) nomalImageName:nil selectImageName:nil target:self action:@selector(nextAction)];
        
        
    }
    return _nextBtn;
    
    
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
