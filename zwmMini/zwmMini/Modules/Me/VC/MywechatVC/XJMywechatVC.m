//
//  XJMywechatVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMywechatVC.h"

@interface XJMywechatVC ()

@property(nonatomic,strong) UIImageView *wxIV;
@property(nonatomic,strong) UITextField *wxTF;
@property(nonatomic,copy) NSString *wxStr;
@property(nonatomic,strong) UIView *lineV;
@property(nonatomic,strong) UIButton *fillinBtn;

@end

@implementation XJMywechatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = defaultWhite;
    self.title = @"我的微信号";
    self.wxStr = NULLString(XJUserAboutManageer.uModel.wechat.no)?@"":XJUserAboutManageer.uModel.wechat.no;
    [self setUpUI];
    [self showNavRightButton:@"保存" action:@selector(rightAction) image:nil imageOn:nil];
}

- (void)rightAction{
    
//    if (NULLString(self.wxStr)) {
//        [MBManager showBriefAlert:@"请输入微信号"];
//        return;
//    }
    NSDictionary *param = @{@"wechat_no":self.wxStr};
    [MBManager showWaitingWithTitle:@"保存微信号中..."];
    [AskManager POST:API_UPDATA_JOBS dict:param.mutableCopy succeed:^(id data, XJRequestError *rError) {
        [MBManager hideAlert];

        if (!rError) {
            
            XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
            XJUserAboutManageer.uModel = umodel;
            [self.navigationController popViewControllerAnimated:YES];
            [MBManager showBriefAlert:@"保存成功"];

        }
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];

    }];
    
}


- (void)setUpUI{
    
    [self.view addSubview:self.wxIV];
    [self.wxTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wxIV);
        make.left.equalTo(self.wxIV.mas_right).offset(12);
        make.right.equalTo(self.view).offset(-17);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wxIV.mas_bottom).offset(15);
        make.left.equalTo(self.wxIV);
        make.right.equalTo(self.wxTF);
        make.height.mas_equalTo(1);

    }];
    UILabel *exLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultGray text:@"" font:defaultFont(14) textInCenter:NO];
    exLb.numberOfLines = 2;
    NSMutableString *phonestr = [[NSMutableString alloc] initWithString:XJUserAboutManageer.uModel.phone];
    if (!NULLString(phonestr)) {
        [phonestr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    exLb.text = [NSString stringWithFormat:@"您的微信号是您当前登录的手机号号码%@?",phonestr];
    [exLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineV.mas_bottom).offset(6);
        make.left.equalTo(self.wxIV);
        make.right.equalTo(self.wxTF);
        
    }];
    
    [self.fillinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineV);
        make.top.equalTo(exLb.mas_bottom).offset(30);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(44);
    }];
    self.fillinBtn.layer.borderColor = defaultGray.CGColor;
    self.fillinBtn.layer.borderWidth = 1;
    self.fillinBtn.layer.cornerRadius = 22;
    self.fillinBtn.layer.masksToBounds = YES;
    

    
    NSString *exstr = @"温馨提示 \n* 填写虚假微信号可能面临封禁，不再推荐等处理\n* 被举报、被差评次数过多将不再被推荐";
    UILabel *bottomexLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:defaultGray text:exstr font:defaultFont(14) textInCenter:NO];
    bottomexLb.numberOfLines = 0;
    [bottomexLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.left.equalTo(self.wxIV);
        make.right.equalTo(self.wxTF);
    }];


    
}
- (void)wxTextChange:(UITextField *)tf{
    self.wxStr = tf.text;
}

- (void)fillinAction{
    
    self.wxTF.text =  XJUserAboutManageer.uModel.phone;
    self.wxStr =  XJUserAboutManageer.uModel.phone;;
}


#pragma mark lazy

- (UIImageView *)wxIV{
    if (!_wxIV) {
        _wxIV = [XJUIFactory creatUIImageViewWithFrame:CGRectMake(17, 43, 30, 25) addToView:nil imageUrl:nil placehoderImage:@"mywechatimg"];
    }
    return _wxIV;
    
}
- (UITextField *)wxTF{
    if (!_wxTF) {
        _wxTF = [XJUIFactory creatUITextFiledWithFrame:CGRectZero addToView:self.view textColor:defaultRedColor textFont:defaultFont(17) placeholderText:@"请输入您的微信号" placeholderTectColor:defaultRedColor placeholderFont:defaultFont(17) delegate:self];
        _wxTF.text = self.wxStr;
        [_wxTF addTarget:self action:@selector(wxTextChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _wxTF;
    
}
- (UIView *)lineV{
    if (!_lineV) {
        
        _lineV = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultLineColor];
    }
    return _lineV;
    
}
- (UIButton *)fillinBtn{
    if (!_fillinBtn) {
        
        _fillinBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.view backColor:defaultWhite nomalTitle:@"直接填入" titleColor:defaultBlack titleFont:defaultFont(15) nomalImageName:nil selectImageName:nil target:self action:@selector(fillinAction)];
    }
    return _fillinBtn;
    
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
