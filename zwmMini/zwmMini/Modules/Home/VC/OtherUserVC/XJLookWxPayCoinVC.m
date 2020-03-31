//
//  XJLookWxPayCoinVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/7.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJLookWxPayCoinVC.h"
#import "XJPayCoinModel.h"
#import "XJLookWxBalanceModel.h"
#import "XJMyCoinCollectionViewCell.h"
#import "TYAttributedLabel.h"
#import "XJRechargeProtocalVC.h"
#import "XJNaviVC.h"
#import "XYIAPKit.h"
#import "XJCoinModel.h"

static NSString *collectionIdentifier = @"mycoinCollectionidentifier";
@interface XJLookWxPayCoinVC ()<UICollectionViewDelegate,UICollectionViewDataSource,TYAttributedLabelDelegate>

@property(nonatomic,strong) XJLookWxBalanceModel *bModel;
@property(nonatomic,strong) NSMutableArray *payArray;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UILabel *titleLb;
@property(nonatomic,strong) UIImageView *coinIV;
@property(nonatomic,strong) UILabel *moneyLb;
@property(nonatomic,strong) UILabel *explainLb;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSIndexPath *lastIndexPath;
@property(nonatomic,strong) XJPayCoinModel *seletpaymodel;
@property (nonatomic,strong) TYAttributedLabel *payAgreementLab;//充值协议
@property(nonatomic,strong) UIView *rechargeBtnView;
@property(nonatomic,strong) UIButton *rechargeBtn;




@end

@implementation XJLookWxPayCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(0, 0, 0, 0.6);
    self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self getCoinList];//获取内购数据
    [self refreshBlance];//获取当前余额
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
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(45);
    }];
    
    [self.coinIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLb.mas_bottom).offset(34);
        make.left.equalTo(self.bgView).offset(17);
        make.width.height.mas_equalTo(22);
    }];
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinIV.mas_right).offset(8);
        make.centerY.equalTo(self.coinIV);
        
    }];
    [self.explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.centerY.equalTo(self.coinIV);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinIV.mas_bottom).offset(22);
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(65);
    }];
    [self.payAgreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionView).offset(20);
        make.top.equalTo(self.collectionView.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(220);
    }];
    [self.rechargeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.payAgreementLab.mas_bottom).offset(5);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(50);
    }];
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rechargeBtnView);
    }];
}


//充值（查看微信和私信you币不足都在这充值）
- (void)recharAction:(UIButton *)btn{
    
    NSLog(@"充值");
    NSLog(@"%@",self.seletpaymodel.production_id);
    //充值成功后购买
    [MBManager showLoading];
    [[XYStore defaultStore] addPayment:self.seletpaymodel.production_id success:^(SKPaymentTransaction *transaction) {
        
        //商品id  production_id
        //苹果订单 transactionIdentifier
        // transactionDate
        
        NSLog(@"=======%@",transaction);
        NSLog(@"充值成功");
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
        NSDictionary *dic = @{@"productIdentifier":self.seletpaymodel.production_id,@"transactionIdentifier":transaction.transactionIdentifier,@"receipt":receipt};
                    
            [AskManager POST:API_RECHARGE_SUCCESS_POST dict:dic.mutableCopy succeed:^(id data, XJRequestError *rError) {
                
                if (!rError) {
                  
//                    [MBManager showBriefAlert:@"购买成功"];
                    
                    [self getCoinBalanceData];
                    
                }
                [MBManager hideAlert];
                
            } failure:^(NSError *error) {
                [MBManager hideAlert];
                
            }];
            
    
        [MBManager hideAlert];
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        
        NSLog(@"%@",error);
        
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"充值失败"];
        [AskManager POST:API_RECHARGE_FAIL_POST dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    
}
- (void)getCoinList{
    
    [MBManager showLoading];
    [AskManager GET:API_LOOKWX_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            for (NSDictionary *dic in data) {
                XJPayCoinModel *pmodel = [XJPayCoinModel yy_modelWithDictionary:dic];
                [self.payArray addObject:pmodel];
            }
            self.seletpaymodel = self.payArray.firstObject;
            [self.collectionView reloadData];

        }
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        [MBManager hideAlert];
        
    }];
    
}
//刚进来刷新余额
- (void)refreshBlance{
    
    [AskManager GET:API_MY_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJCoinModel *coinmodel = [XJCoinModel yy_modelWithDictionary:data];
            self.moneyLb.text = [NSString stringWithFormat:@"么币余额:%ld",(long)coinmodel.mcoin];
         
        }
    } failure:^(NSError *error) {
        
    }];
}

//购买成功获取余额
- (void)getCoinBalanceData{
    
    [AskManager GET:API_MY_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJCoinModel *coinmodel = [XJCoinModel yy_modelWithDictionary:data];
            self.moneyLb.text = [NSString stringWithFormat:@"%ld",(long)coinmodel.mcoin];
            XJUserModel *oldmodel = XJUserAboutManageer.uModel;
            oldmodel.mcoin = coinmodel.mcoin;
            XJUserAboutManageer.uModel = oldmodel;
            
            [self dismissViewControllerAnimated:YES completion:nil];

            if (self.successBlcok) {
                self.successBlcok([NSString stringWithFormat:@"%ld",coinmodel.mcoin]);
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)closeAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLayoutSubviews{
    
    [self.bgView cornerRadiusViewWithTopRadius:10];

}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"充值协议"]) {
            //跳转到充值协议
            XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:[XJRechargeProtocalVC new]];
            [self presentViewController:nav animated:NO completion:nil];
            
        }
    }
}

#pragma mark collectionViewDelegate dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-44)/3.f, 65);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);//（上、左、下、右）
}
#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 7.f;
}

#pragma mark  定义每个UICollectionView的纵向间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 24.f;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.payArray.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XJMyCoinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XJMyCoinCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    BOOL isselect = NO;
    if (indexPath.item == 0) {
        isselect = YES;
    }
    [cell setUpContet:self.payArray[indexPath.item] isSelect:isselect];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.seletpaymodel = self.payArray[indexPath.item];
    XJMyCoinCollectionViewCell *cell = (XJMyCoinCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setUpContet:self.seletpaymodel isSelect:YES];
    if (self.lastIndexPath) {
        XJMyCoinCollectionViewCell *cell = (XJMyCoinCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.lastIndexPath];
        [cell setUpContet:self.payArray[self.lastIndexPath.item] isSelect:NO];
    }
    self.lastIndexPath = indexPath;
    
}



#pragma mark lazy
- (NSMutableArray *)payArray{
    if (!_payArray) {
        _payArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _payArray;
    
}

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

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultRedColor text:[NSString stringWithFormat:@"%ld么币",(NSInteger)self.userModel.wechat_price_mcoin] font:defaultFont(28) textInCenter:YES];
        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
    
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
- (UILabel *)explainLb{
    if (!_explainLb) {
        _explainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgView textColor:defaultGray text:@"余额不足,请充值" font:defaultFont(15) textInCenter:YES];
    }
    return _explainLb;
}
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = defaultWhite;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[XJMyCoinCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
        [self.bgView addSubview:_collectionView];
    }
    return _collectionView;
}
- (TYAttributedLabel *)payAgreementLab {
    if (!_payAgreementLab) {
        _payAgreementLab =[[TYAttributedLabel alloc]initWithFrame:CGRectZero];
        _payAgreementLab.textAlignment = kCTTextAlignmentLeft;
        _payAgreementLab.textColor= RGB(128, 128, 128);
        
        _payAgreementLab.font= [UIFont systemFontOfSize:12];
        _payAgreementLab.text = @"付费即代表已阅读并同意";
        _payAgreementLab.delegate = self;
        [ _payAgreementLab appendLinkWithText:@"《充值协议》" linkFont:[UIFont systemFontOfSize:12 ] linkColor: RGB(1, 123, 255) underLineStyle:kCTUnderlineStyleNone linkData:@"充值协议"];
        //        [ _payAgreementLab appendLinkWithText:@"|  苹果支付教程" linkFont:[UIFont systemFontOfSize:12 ] linkColor: RGB(128, 128, 128) underLineStyle:kCTUnderlineStyleNone linkData:@"苹果支付教程"];
        [self.bgView addSubview:_payAgreementLab];
    }
    return _payAgreementLab;
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
        
        _rechargeBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.rechargeBtnView backColor:defaultClearColor nomalTitle:@"确认充值并购买" titleColor:defaultWhite titleFont:defaultFont(17) nomalImageName:nil selectImageName:nil target:self action:@selector(recharAction:)];
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
