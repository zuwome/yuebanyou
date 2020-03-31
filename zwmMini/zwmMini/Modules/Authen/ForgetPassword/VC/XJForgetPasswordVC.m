//
//  XJForgetPasswordVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJForgetPasswordVC.h"
#import "XJSelectAreaCodeVC.h"
#import "XJForgetResetPasswordVC.h"
#import "XJNaviVC.h"

@interface XJForgetPasswordVC ()

@property(nonatomic,strong) UIView *whittBgView;
@property(nonatomic,strong) UILabel *areaCodeLb;
@property(nonatomic,copy) NSString *selectCode;
@property(nonatomic,copy) NSString *phoneNum;
@property(nonatomic,strong) UITextField *phoneTF;
@property(nonatomic,strong) UIView *gradienView;
@property(nonatomic,strong) UIButton *nextBtn;

@end

@implementation XJForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.phoneNum = @"";
    self.selectCode = @"+86";
    [self creatUI];
}

- (void)creatUI{
 
    self.whittBgView = [XJUIFactory creatUIViewWithFrame:CGRectMake(0, 10, kScreenWidth, 60) addToView:self.view backColor:defaultWhite];
    
    [self.areaCodeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whittBgView).offset(15);
        make.centerY.equalTo(self.whittBgView);
    }];
    
    UIImageView *downiv = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.whittBgView imageUrl:@"" placehoderImage:@"downimg"];
    [downiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.areaCodeLb);
        make.left.equalTo(self.areaCodeLb.mas_right).offset(6);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(4);
    }];
    downiv.userInteractionEnabled = YES;
    UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaCodeAction)];
    [downiv addGestureRecognizer:areaTap];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.areaCodeLb);
        make.left.equalTo(downiv.mas_right).offset(12);
        make.width.mas_equalTo(200);
    }];
    
    [self.gradienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.whittBgView.mas_bottom).offset(103);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(60);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gradienView);
    }];
    
    
}


//选择区号
- (void)areaCodeAction{
    
    NSLog(@"更换区号");
    XJSelectAreaCodeVC *selectVC = [XJSelectAreaCodeVC new];
    
    selectVC.selectedCode = ^(NSString * _Nonnull code) {
        
        self.selectCode = code;
        self.areaCodeLb.text = code;
        
    };
    XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:selectVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

//手机号
- (void)phoneTextChange:(UITextField *)tf{
    
    self.phoneNum = tf.text;
   
}
//下一步
- (void)nextAction{
    if (NULLString(_phoneNum)) {
        [MBManager showBriefAlert:@"手机号不能为空"];
        return;
    }
    NSLog(@"下一步");
    XJForgetResetPasswordVC *resetVC = [XJForgetResetPasswordVC new];
    resetVC.phone = self.phoneNum;
    resetVC.areaCode = self.selectCode;
    [self.navigationController pushViewController:resetVC animated:YES];
    
    
}

//判断手机号

- (void)checkPhoneAndPassword{
    
    if (NULLString(self.phoneNum)) {
        [MBManager showBriefAlert:@"手机号不能为空"];
        return;
    }
//    if (![XJUtils isPhoneNumber:self.phoneNum]) {
//        
//        [MBManager showBriefAlert:@"手机号格式错误"];
//        return;
//    }
   
}

#pragma mark lazy

- (UILabel *)areaCodeLb{
    if (!_areaCodeLb) {
        
        _areaCodeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.whittBgView textColor:defaultBlack text:@"+86" font:defaultFont(17) textInCenter:NO];
        _areaCodeLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *areaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaCodeAction)];
        [_areaCodeLb addGestureRecognizer:areaTap];
    }
    return _areaCodeLb;
}

- (UITextField *)phoneTF{
    if (!_phoneTF) {
        _phoneTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self.whittBgView textColor:defaultBlack textFont:defaultFont(17) placeholderText:@"请输入手机号" placeholderTectColor:RGB(205, 205, 205) placeholderFont:defaultFont(17) delegate:self];
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
         [_phoneTF addTarget:self action:@selector(phoneTextChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _phoneTF;
    
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
