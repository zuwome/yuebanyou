//
//  XJLookWxEnougCoinVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/10.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJLookWxEnougCoinVC.h"

@interface XJLookWxEnougCoinVC ()

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UIImageView *heartIV;
@property(nonatomic,strong) UILabel *heartLb;
@property(nonatomic,strong) UIView *lineV;
@property(nonatomic,strong) UILabel *needCoinLb;
@property(nonatomic,strong) UIImageView *coinIV;
@property(nonatomic,strong) UILabel *moneyLb;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) UIView *rechargeBtnView;
@property(nonatomic,strong) UIButton *rechargeBtn;


@end

@implementation XJLookWxEnougCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self creatUI];
}
- (void)creatUI{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(355);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.bgView);
        make.width.height.mas_equalTo(50);
    }];
    [self.heartIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(18);
        make.right.equalTo(self.bgView.mas_centerX).offset(-30);
        make.width.height.mas_equalTo(40);
    }];
    [self.heartLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.heartIV);
        make.left.equalTo(self.bgView.mas_centerX).offset(-16);
    }];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heartIV.mas_bottom).offset(18);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(1);
    }];
    [self.needCoinLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.lineV.mas_bottom).offset(26);
    }];
    [self.coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.needCoinLb.mas_bottom).offset(45);
        make.left.equalTo(self.bgView).offset(17);
        make.width.height.mas_equalTo(22);
    }];
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinIV.mas_right).offset(8);
        make.centerY.equalTo(self.coinIV);
        
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLb);
        make.right.equalTo(self.bgView).offset(-17);
        make.width.height.mas_equalTo(18);
    }];
    [self.rechargeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.moneyLb.mas_bottom).offset(22);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(50);
    }];
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rechargeBtnView);
    }];
}
- (void)viewDidLayoutSubviews{
    
    [self.bgView cornerRadiusViewWithTopRadius:10];
    
}
- (void)closeAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//购买
- (void)recharAction:(UIButton *)btn{
    NSLog(@"购买");
    [MBManager showBriefAlert:@"查看中..."];
    [AskManager POST:API_BUY_WX_WITH_(self.userModel.uid) dict:@{@"price":@(self.userModel.wechat_price_mcoin),@"channel":@"pay_for_wechat"}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        //购买成功去刷新页面
        if (!rError) {
            
//            NSLog(@"%@",data);
            [MBManager showBriefAlert:@"查看成功"];
            XJUserModel *oldModel = XJUserAboutManageer.uModel;
            oldModel.mcoin = [data[@"mcoin"] integerValue];
            XJUserAboutManageer.uModel = oldModel;
//            NSLog(@"%ld",XJUserAboutManageer.uModel.mcoin);
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadLookOtherInfo object:self];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];

    }];
    
}

#pragma mark lazy

- (UIView *)bgView{
    
    if (!_bgView) {
        
        _bgView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.view backColor:defaultWhite];
    }
    return _bgView;
    
}

- (UIButton *)closeBtn{
    
    if (!_closeBtn) {
        _closeBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bgView backColor:defaultWhite nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"daximg" selectImageName:@"daximg" target:self action:@selector(closeAction)];
    }
    return _closeBtn;
}
- (UIImageView *)heartIV{
    if (!_heartIV) {
        _heartIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@"redheartimg"];
    }
    return _heartIV;
    
}
- (UILabel *)heartLb{
    if (!_heartLb) {
        
        _heartLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultBlack text:[NSString stringWithFormat:@"%ld人看过觉得好",self.userModel.wechat.good_comment_count] font:defaultFont(15) textInCenter:YES];
    }
    return _heartLb;
    
}
- (UIView *)lineV{
    
    if (!_lineV) {
        _lineV = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.bgView backColor:defaultLineColor];
    }
    return _lineV;
}
- (UILabel *)needCoinLb{
    if (!_needCoinLb) {
        
        _needCoinLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultBlack text:[NSString stringWithFormat:@"%ld么币",(NSInteger)self.userModel.wechat_price_mcoin] font:defaultFont(28) textInCenter:YES];
    }
    return _needCoinLb;
    
}
- (UIImageView *)coinIV{
    
    if (!_coinIV) {
        _coinIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.bgView imageUrl:nil placehoderImage:@"coinimg"];
    }
    return _coinIV;
}
- (UILabel *)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultBlack text:[NSString stringWithFormat:@"么币余额: %ld",XJUserAboutManageer.uModel.mcoin] font:defaultFont(17) textInCenter:YES];
    }
    return _moneyLb;
}
- (UIButton *)selectBtn{
    
    if (!_selectBtn) {
        _selectBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bgView backColor:defaultWhite nomalTitle:nil titleColor:nil titleFont:nil nomalImageName:@"reddago" selectImageName:@"" target:self action:nil];
    }
    return _selectBtn;
}
- (UIView *)rechargeBtnView{
    
    if (!_rechargeBtnView) {
        
        _rechargeBtnView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.bgView backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 50)];
        [_rechargeBtnView.layer addSublayer:gradientLayer];
        _rechargeBtnView.layer.cornerRadius = 25;
        _rechargeBtnView.layer.masksToBounds = YES;
    }
    return _rechargeBtnView;
}
- (UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        
        _rechargeBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.rechargeBtnView backColor:defaultClearColor nomalTitle:@"购买" titleColor:defaultWhite titleFont:defaultFont(17) nomalImageName:nil selectImageName:nil target:self action:@selector(recharAction:)];
    }
    return _rechargeBtn;
    
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
