//
//  XJMyCoinVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyCoinVC.h"
#import "XJCoinModel.h"
#import "XJBillRecordVC.h"
#import "XJPayCoinModel.h"
#import "XJMyCoinView.h"
#import "XJRechargeProtocalVC.h"
#import "XYIAPKit.h"


@interface XJMyCoinVC ()<XJMyCoinViewDelegate>

@property(nonatomic,strong) XJMyCoinView *myCoinView;
@property(nonatomic,strong) XJCoinModel *mycoinModel;//余额
@property(nonatomic,strong) NSMutableArray *payDataArray;
@property(nonatomic,strong) XJPayCoinModel *seletpaymodel;

@end

@implementation XJMyCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"么币";
    self.view.backgroundColor = defaultWhite;
    [self showNavRightButton:@"账单记录" action:@selector(rightAction) image:nil imageOn:nil];
    [self.view addSubview:self.myCoinView];
    [self getCoinBalanceData];
    [self getPayCoinData];
    
}


- (void)rightAction{
    
    [self.navigationController pushViewController:[XJBillRecordVC new] animated:YES];
}

- (void)clickRechargeWithPayModel:(XJPayCoinModel *)payModel isAgreement:(BOOL)agree{
    @WeakObj(self);
    self.seletpaymodel = payModel;
    NSLog(@"%ld %@",self.seletpaymodel.money,agree ? @"yes":@"no");
    if (!agree) {
        [MBManager showBriefAlert:@"请阅读并同意充值协议"];
        return;
    }
    [MBManager showLoading];
   bool iscan =  [XYStore canMakePayments];
    
    [[XYStore defaultStore] addPayment:payModel.production_id success:^(SKPaymentTransaction *transaction) {
        
        
       //商品id  production_id
       //苹果订单 transactionIdentifier
       // transactionDate
        
        NSLog(@"=======%@",transaction);
        NSLog(@"充值成功");
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
        NSDictionary *dic = @{@"productIdentifier":payModel.production_id,@"transactionIdentifier":transaction.transactionIdentifier,@"receipt":receipt};
        
        
            [AskManager POST:API_RECHARGE_SUCCESS_POST dict:dic.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
                if (!rError) {
                    
                    [MBManager showBriefAlert:@"购买成功"];
                    [weakself getCoinBalanceData];
                    if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(recharged:)]) {
                        [weakself.delegate recharged:weakself];
                    }
                    
                }
                [MBManager hideAlert];
                
            } failure:^(NSError *error) {
                [MBManager hideAlert];
                
            }];
            
      
        
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        
        NSLog(@"%@",error);
        [MBManager hideAlert];
        [AskManager POST:API_RECHARGE_FAIL_POST dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
        } failure:^(NSError *error) {
            
        }];
        

    }];
}

- (void)clickProtocal{
    NSLog(@"充值协议");
    [self.navigationController pushViewController:[XJRechargeProtocalVC new] animated:YES];
}
- (void)clickCourse{
    NSLog(@"支付教程");
}

//获取余额
- (void)getCoinBalanceData{
    
    [AskManager GET:API_MY_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            self.mycoinModel = [XJCoinModel yy_modelWithDictionary:data];
            [self.myCoinView setUpCoinLabel:self.mycoinModel];
            XJUserModel *oldmodel = XJUserAboutManageer.uModel;
            oldmodel.mcoin = self.mycoinModel.mcoin;
            XJUserAboutManageer.uModel = oldmodel;
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
//获取内购coin数据
- (void)getPayCoinData{
    [AskManager GET:API_PAY_COIN_DATA_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            for (NSDictionary *dic in data) {
                
                XJPayCoinModel *pmodel = [XJPayCoinModel yy_modelWithDictionary:dic];
                [self.payDataArray addObject:pmodel];
            }
            self.seletpaymodel = self.payDataArray.firstObject;
            [self.myCoinView setUpCollection:self.payDataArray];
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark lazy
- (XJMyCoinView *)myCoinView{
    if (!_myCoinView) {
        _myCoinView = [[XJMyCoinView alloc] initWithFrame:self.view.frame];
        _myCoinView.delegate = self;
    }
    return _myCoinView;
    
}
- (NSMutableArray *)payDataArray{
    if (!_payDataArray) {
        _payDataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _payDataArray;
}

@end
