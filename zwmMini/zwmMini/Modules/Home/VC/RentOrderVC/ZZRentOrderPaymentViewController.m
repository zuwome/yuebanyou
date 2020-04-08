//
//  ZZRentOrderPaymentViewController.m
//  kongxia
//
//  Created by qiming xiao on 2019/10/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZRentOrderPaymentViewController.h"
//#import "ZZRechargeViewController.h"
#import "ZZRentOrderPayCompleteViewController.h"
#import "ZZRentOrderInfoViewController.h"

#import "ZZRentOrderHeaderView.h"
#import "ZZRentOrderPayCell.h"

#import "Pingpp.h"
#import "ZZRentDropdownModel.h"
#import "ZZOrder.h"
#import "MJExtension.h"
#import "XJChatViewController.h"
#import "ZZRentChooseSkillViewController.h"

@interface ZZRentOrderPaymentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,   copy) NSArray<NSArray<NSNumber *> *> *tableViewCellTypes;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) NSInteger paySelectIndex;

@property (nonatomic, assign) CGFloat price;

@end

@implementation ZZRentOrderPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchBalance];
    
    [self createOrderCellTypes];
    [self layout];
}

#pragma mark - private method
- (void)createOrderCellTypes {
    NSMutableArray *array = @[].mutableCopy;
    [array addObject:@[
        @(CellTypePayWallet),
        @(CellTypePayWechat),
        @(CellTypePayWallet)
    ]];
    self.tableViewCellTypes = array.copy;
}

- (void)managerPayMethod {
    NSString *method = XJUserAboutManageer.lastPayMethod;
    if ([method isEqualToString:@"packet"]) {
        _paySelectIndex = 0;
    }
    else if ([method isEqualToString:@"weixin"]) {
        _paySelectIndex = 1;
    }
    else if ([method isEqualToString:@"zhifubao"]) {
        _paySelectIndex = 2;
    }
    else {
        _paySelectIndex = 1;
    }
}

//保存搜索过的地址
- (void)backupLocationArray {
    if (self.addressModel) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:XJUserAboutManageer.locationArray];
        __block BOOL have = NO;
        [array enumerateObjectsUsingBlock:^(ZZRentDropdownModel *downModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([downModel.name isEqualToString:self.addressModel.name]) {
                have = YES;
                *stop = YES;
            }
        }];
        if (!have) {
            if (array.count == 100) {
                [array removeLastObject];
            }
            [array insertObject:self.addressModel atIndex:0];
        }
        [XJUserAboutManageer setLocationArray:array];
    }
}

- (void)savePayMethod {
    switch (_paySelectIndex) {
        case 0: {
            XJUserAboutManageer.lastPayMethod = @"packet";
            break;
        }
        case 1: {
            XJUserAboutManageer.lastPayMethod = @"weixin";
            break;
        }
        case 2: {
            XJUserAboutManageer.lastPayMethod = @"zhifubao";
            break;
        }
        default:
            break;
    }
}

//保存订单信息
- (void)backupOrder {
    ZZCacheOrder *cacheOrder = [[ZZCacheOrder alloc] init];
    cacheOrder.hours = _order.hours;
    cacheOrder.dated_at = _order.dated_at;
    cacheOrder.address = _order.address;
    cacheOrder.currentDate = [NSDate date];
    cacheOrder.checkWeChat = _order.wechat_service;
    CGFloat lat = [_order.loc.lat floatValue];
    CGFloat lng = [_order.loc.lng floatValue];
    cacheOrder.loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    cacheOrder.city = _order.city.name;
    if (_order.dated_at_type == 1) {
        cacheOrder.isQuickTime = YES;
    } else {
        cacheOrder.isQuickTime = NO;
    }
    XJUserAboutManageer.cacheOrder = cacheOrder;
}

/**
 *  计算预付款
 */
- (NSString *)calculatePrice {
    BOOL isMoreAccurate = NO;
    double orderPrice = [_order pureTotalPrice];
    double totalPrice = orderPrice;
    double advancePrice;
    
    if (totalPrice < 10) {
        advancePrice = totalPrice;
    }
    else {
        // 意向金采取四舍五入的形式
        advancePrice = roundf(totalPrice * 0.05);
        isMoreAccurate = YES;
    }
    
    if (_order.wechat_service) {
        totalPrice += _order.wechat_price;
        advancePrice += _order.wechat_price;
    }
    else {
        totalPrice += [_order.xdf_price doubleValue];
        advancePrice += [_order.xdf_price doubleValue];
    }

    if (isMoreAccurate) {
        return  [NSString stringWithFormat:@"确认支付 ¥%.2lf",advancePrice];
    }
    else {
        return [NSString stringWithFormat:@"确认支付 ¥%.0lf",advancePrice];
    }
}

#pragma mark - response method
- (void)navigationLeftBtnClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"你与TA的距离只差最后一步了，确认放弃支付吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"约TA" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)confirm:(UIButton *)sender {
    
    if (_isEdit) {
        _price = 0;
    }
    else {
        _price = _order.advancePrice.doubleValue;
    }
    
    if (!_isEdit && _paySelectIndex == 0 && XJUserAboutManageer.uModel.balance < _price) {
        [ZZHUD showErrorWithStatus:@"钱包当前余额不足,请选择其他支付方式"];
//        [UIAlertView showWithTitle:@"钱包当前余额不足" message:nil cancelButtonTitle:@"其他支付方式" otherButtonTitles:@[@"马上充值"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [self gotoRechargeView];
//            }
//        }];
        return;
    }
    
    __weak typeof(self) Weakself = self;;
    sender.enabled = NO;
    if (_isEdit) {
        [ZZHUD showWithStatus:@"正在修改.."];
        [_order update:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD dismiss];
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdateOrder object:self userInfo:data];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OrderStatusChante object:nil];
                }];
                
                [self backupLocationArray];
            }
        }];
    } else {
        [ZZHUD showWithStatus:@"正在下单..."];
        [_order addDeposit:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
            sender.enabled = YES;
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"已发出邀约，请等待对方回应。详情查看我的档期"];
                ZZOrder *order = [[ZZOrder alloc] initWithDictionary:data error:nil];
                Weakself.order.id = order.id;
                Weakself.order.status = order.status;
                [Weakself backupLocationArray];
                
                [Weakself pay];
            }
        }];
    }
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewCellTypes[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCellType type = (OrderCellType)[self.tableViewCellTypes[indexPath.section][indexPath.row] integerValue];
    
    if (type == CellTypePayWallet || type == CellTypePayWechat || type == CellTypePayAliPay) {
        ZZRentOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRentOrderPayCell" forIndexPath:indexPath];
        
        [cell setIndexPath:indexPath selectIndex:_paySelectIndex];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCellType type = (OrderCellType)[self.tableViewCellTypes[indexPath.section][indexPath.row] integerValue];
    if (type == CellTypePayWallet || type == CellTypePayWechat || type == CellTypePayAliPay) {
        _paySelectIndex = indexPath.row;
        [self.tableView reloadData];
    }
}

#pragma mark - Request
- (void)gotoRechargeView {
    __weak typeof(self) Weakself = self;;
//    ZZRechargeViewController *controller = [[ZZRechargeViewController alloc] init];
//    controller.rechargeCallBack = ^{
//        [ZZHUD showWithStatus:@"充值成功，余额更新中..."];
//        [weakSelf fetchBalance];
//    };
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)fetchBalance {
    [XJUserAboutManageer.uModel getBalance:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            [ZZHUD dismiss];
            //更新余额
            XJUserModel *loginer = XJUserAboutManageer.uModel;
            loginer.balance = [data[@"balance"] doubleValue];
            XJUserAboutManageer.uModel = loginer;
//            [[ZZUserHelper shareInstance] saveLoginer:[loginer toDictionary] postNotif:NO];
            
            [self.tableView reloadData];
        }
    }];
}

- (void)pay {
    NSString *channel = @"";
    switch (_paySelectIndex) {
        case 0: {
            channel = @"wallet";
            break;
        }
        case 1:
            channel = @"wx";
            break;
        case 2: {
            channel = @"alipay";
            break;
        }
        default:
            break;
    }
  
    [ZZHUD showWithStatus:@"正在准备付款"];
      __weak typeof(self) Weakself = self;
    [_order advancePay:channel status:_order.status next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            if (Weakself.paySelectIndex == 0) {
                XJUserModel *user = XJUserAboutManageer.uModel;
                user.balance = user.balance - Weakself.price;
                XJUserAboutManageer.uModel = user;
                
                // 目前只有当优享邀约打开之后才需要通知个人页刷洗一下下
                if (Weakself.order.wechat_service) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KMsg_CreateOrderNotification object:nil];
                }
                
                [Weakself gotoChatView];
            } else {
                [Pingpp createPayment:data
                       viewController:self
                         appURLScheme:@"zuwoma"
                       withCompletion:^(NSString *result, PingppError *error) {
                           if ([result isEqualToString:@"success"]) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   // 目前只有当优享邀约打开之后才需要通知个人页刷洗一下下
                                   if (Weakself.order.wechat_service) {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:KMsg_CreateOrderNotification object:nil];
                                   }
                                   [Weakself gotoChatView];
//                                   [Weakself showPayCompleteView];
                               });
                           } else {
                               // 支付失败或取消
                               NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                           }
                       }];
            }
        }
    }];

}

#pragma mark - Navigator
- (void)showPayCompleteView {
    XJUserAboutManageer.unreadModel.order_ongoing_count++;
    
    [self savePayMethod];
    [self backupOrder];
    
    ZZRentOrderPayCompleteViewController *vc = [[ZZRentOrderPayCompleteViewController alloc] init];
    vc.order = _order;
    vc.fromChat = _fromChat;
    vc.user = _user;
    vc.addressModel = _addressModel;
      __weak typeof(self) Weakself = self;
    [vc setCallBack:^{
        if (Weakself.callBack) {
            Weakself.callBack();
        }
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoChatView {
    XJUserAboutManageer.unreadModel.order_ongoing_count++;
    XJChatViewController *conversationVC = [[XJChatViewController alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = _order.to.uid;
    RCUserInfo *userinfo = [[RCIM sharedRCIM] getUserInfoCache:_order.to.uid];
    if (userinfo == nil) {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:_order.to.uid completion:^(RCUserInfo *userInfo) {
            conversationVC.title = _order.to.nickname;
        }];
    }else{
        conversationVC.title = _order.to.nickname;
    }
    
    NSMutableArray<__kindof UIViewController *> *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    NSInteger index = array.count - 2;
//    if (array.count > index) {
//        [array removeObjectAtIndex:(array.count - 2)];
//        [array removeObjectAtIndex:(array.count - 2)];
//    }
    while ([array.lastObject isKindOfClass:[ZZRentOrderPaymentViewController class]] || [array.lastObject isKindOfClass: [ZZRentOrderInfoViewController class]] || [array.lastObject isKindOfClass: [ZZRentChooseSkillViewController class]]) {
        [array removeLastObject];
    }
    [array addObject:conversationVC];
    [self.navigationController setViewControllers:array animated:YES];
    
//
//    [self savePayMethod];
//    [self backupOrder];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (_fromChat) {
//            for (UIViewController *ctl in self.navigationController.viewControllers) {
//                if ([ctl isKindOfClass:[ZZChatViewController class]]) {
//                    if (_callBack) {
//                        _callBack();
//                    }
//                    [self.navigationController popToViewController:ctl animated:YES];
//                    break;
//                }
//            }
//        }
//        else {
//            ZZChatViewController *controller = [[ZZChatViewController alloc] init];
//            controller.isFromRentOrder = YES;
//            [ZZRCUserInfoHelper setUserInfo:_user];
//            controller.user = _user;
//            controller.nickName = _user.nickname;
//            controller.uid = isNullString(_user.uid) ? _user.uuid : _user.uid;
//            controller.portraitUrl = _user.avatar;
//            controller.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:controller animated:YES];
//
//            if (_order.wechat_service) {
//                controller.shouldShowWeChat = YES;
//            }
//
//            [[ZZTabBarViewController sharedInstance] managerAppBadge];
//
//            NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//            NSInteger index = array.count - 2;
//            if (array.count > index) {
//                [array removeObjectAtIndex:(array.count - 2)];
//                [array removeObjectAtIndex:(array.count - 2)];
//            }
//            self.navigationController.viewControllers = array;
//        }
//    });
}

#pragma mark - Layout
- (void)layout {
    self.navigationItem.title = @"选择支付方式";
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - getters and setters
- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = RGB(244, 203, 7);
        [_confirmBtn setTitle:[self calculatePrice] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:RGB(63, 58, 58) forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.layer.cornerRadius = 25.0;
    }
    return _confirmBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 61.5;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGB(247, 247, 247);
        
        ZZRentOrderHeaderView *headerView = [[ZZRentOrderHeaderView alloc] init];
        headerView.frame = CGRectMake(0.0, 0.0, kScreenWidth, 87.5);
        headerView.titleLabel.text = @"预约信息";
        headerView.subTitleLabel.text = @"预约需要支付一定的意向金，对方接受后，方可支付全款。款项将由平台全程担保，预约不成功，意向金将按规则返还。";
        _tableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth, 100.0)];
        [footerView addSubview: self.confirmBtn];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 15 * 2, 50.0));
        }];
        _tableView.tableFooterView = footerView;
        
        [_tableView registerClass:[ZZRentOrderPayCell class]
           forCellReuseIdentifier:@"ZZRentOrderPayCell"];
    }
    return _tableView;
}

@end
