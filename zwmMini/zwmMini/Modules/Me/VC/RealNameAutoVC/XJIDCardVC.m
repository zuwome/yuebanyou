//
//  XJIDCardVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJIDCardVC.h"
#import "XJNumberInputView.h"
@interface XJIDCardVC ()

@property(nonatomic,strong) UILabel *hintLb;
@property(nonatomic,copy) NSString *nameStr;
@property(nonatomic,copy) NSString *numStr;
@property(nonatomic,strong) UIButton *commintBtn;
@property(nonatomic,strong) UIImageView *statusIV;





@end

@implementation XJIDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self creatUI];

}


- (void)creatUI{
    
    [self.hintLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(32);
    }];
    
    XJNumberInputView *nameView = [[XJNumberInputView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 50)];
    nameView.nameStr = @"姓名";
    nameView.placeholderStr = @"请输入真实姓名";
    [self.view addSubview:nameView];

    
    XJNumberInputView *numberView = [[XJNumberInputView alloc] initWithFrame:CGRectMake(0, 106, kScreenWidth, 50)];
    numberView.nameStr = @"身份证";
    numberView.placeholderStr = @"请输入身份证号码";
    [self.view addSubview:numberView];

    nameView.block = ^(NSString * _Nonnull inputStr) {
        self.nameStr = inputStr;
    };
    
    numberView.block = ^(NSString * _Nonnull inputStr) {
        self.numStr = inputStr;
    };
    
    UILabel *exLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultGray text:@"＊为确保您提现顺利，实名认证身份信息必须与提款账户认证的身份信息一致，伴友不会向第三方泄漏您的任何信息" font:defaultFont(10) textInCenter:YES];
    exLb.numberOfLines = 0;
    [exLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(numberView.mas_bottom).offset(5);
    }];
    
    [self.commintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(exLb.mas_bottom).offset(15);
        make.width.mas_equalTo(345);
        make.height.mas_equalTo(50);
    }];
    self.commintBtn.layer.cornerRadius = 25;
    self.commintBtn.layer.masksToBounds = YES;
    
    [self.statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(30);
        make.width.height.mas_equalTo(75);
    }];
    UILabel *stasLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultGray text:@"身份证已认证" font:defaultFont(15) textInCenter:YES];
    [stasLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusIV.mas_bottom).offset(15);
        make.centerX.equalTo(self.statusIV);
    }];
    if (self.type == 2) {
        
        nameView.inputnumStr = XJUserAboutManageer.uModel.realname.name;
//        NSMutableString *codstr = [[NSMutableString alloc] initWithString:XJUserAboutManageer.uModel.realname.code];
//        [codstr replaceCharactersInRange:NSMakeRange(codstr.length-6, 4) withString:@"****"];
        numberView.inputnumStr = XJUserAboutManageer.uModel.realname.code;
        self.commintBtn.hidden = YES;
        numberView.isCanEdit = NO;
        nameView.isCanEdit = NO;
    }
    
    if (self.type != 2) {
        self.statusIV.hidden = YES;
        stasLb.hidden = YES;
    }
                         
}

- (void)comminAction{
    if (NULLString(self.nameStr)) {
        [MBManager showBriefAlert:@"请输入姓名"];
        return;
    }
    if (NULLString(self.numStr)) {
        [MBManager showBriefAlert:@"请输入身份证号"];
        return;

    }
    if (self.numStr.length != 15 && self.numStr.length != 18) {
        [MBManager showBriefAlert:@"请输入15或18位身份证号!"];
        return;

    }
    [self showAlerVCtitle:@"提示" message:@"请务必使用本人身份证进行认证，认证成功后，将锁定您的出生日期和性别。\n若提款账户信息与您的身份证信息不一致，将无法进行提款操作" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{
        
        [MBManager showWaitingWithTitle:@"认证中..."];
        [AskManager POST:API_REALNAME_POST dict:@{@"name":self.nameStr,@"code":self.numStr}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
//            NSLog(@"realnamdata = %@",data);
            if (!rError) {
                XJRealNameModel *realnameModel = [XJRealNameModel yy_modelWithDictionary:data];
                XJUserModel *umode = XJUserAboutManageer.uModel;
                umode.realname = realnameModel;
                XJUserAboutManageer.uModel = umode;
                [MBManager hideAlert];
                [MBManager showBriefAlert:@"认证成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBManager hideAlert];

            }
            
            
        } failure:^(NSError *error) {
            [MBManager hideAlert];

        }];
        
    } cancelBlock:^{
        
    }];
   
    
}

- (UILabel *)hintLb{
    if (!_hintLb) {
        _hintLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultRedColor text:@"实名认证后的身份证信息不可修改" font:defaultFont(14) textInCenter:YES];
        _hintLb.backgroundColor = RGB(255, 233, 237);
    }
    return _hintLb;
    
}
- (UIButton *)commintBtn{
    
    if (!_commintBtn) {
        _commintBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.view backColor:defaultRedColor nomalTitle:@"提交" titleColor:defaultWhite titleFont:defaultFont(15) nomalImageName:nil selectImageName:nil target:self action:@selector(comminAction)];
    }
    return _commintBtn;
}
- (UIImageView *)statusIV{
    if (!_statusIV) {
        _statusIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.view imageUrl:nil placehoderImage:@"isrealimg"];
        
    }
    return _statusIV;
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
