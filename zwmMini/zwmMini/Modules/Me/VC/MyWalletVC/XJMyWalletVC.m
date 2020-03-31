//
//  XJMyWalletVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyWalletVC.h"
#import "XJMyWalletHeadTbwCell.h"
#import "XJMyWalletContentTbCell.h"
#import "XJBillRecordVC.h"
#import "XJMyCoinVC.h"
#import "XJMyBlanceVC.h"

static NSString *myTableviewheadIdentifier = @"mywallettableviewIdentifierheadcell";
static NSString *myTableviewcontentIdentifier = @"mywallettableviewIdentifiercontentcell";


@interface XJMyWalletVC ()<UITableViewDelegate,UITableViewDataSource,XJMyWalletContentTbCellDelegate, XJMyCoinVCDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *footerView;
@end

@implementation XJMyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UILabel *phoneL = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.view textColor:[UIColor blueColor] text:@"客服电话：4008-520-272" font:defaultFont(15) textInCenter:NO];
    [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-15);
    }];
    phoneL.userInteractionEnabled = YES;
    UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneAction)];
    [phoneL addGestureRecognizer:phonetap];

}


- (void)clickBlance{
    NSLog(@"账号余额");
    [self.navigationController pushViewController:[XJMyBlanceVC new] animated:YES];
    
}
- (void)clickCoin{
    NSLog(@"么币余额");
    XJMyCoinVC *viewController = [[XJMyCoinVC alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)fetchBalance {
    [AskManager GET:API_MY_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJUserModel *oldmdel = XJUserAboutManageer.uModel;
            oldmdel.mcoin = [data[@"mcoin"] integerValue];
            oldmdel.balance = [data[@"balance"] floatValue];
            XJUserAboutManageer.uModel = oldmdel;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - XJMyCoinVCDelegate
- (void)recharged:(XJMyCoinVC *)viewController {
    [self fetchBalance];
}

#pragma mark tableviewDelegate and dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 116;
    }
    return 107;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    if (indexPath.row == 0) {
        XJMyWalletHeadTbwCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewheadIdentifier];
        if (cell == nil) {
            cell = [[XJMyWalletHeadTbwCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewheadIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setUpContent:XJUserAboutManageer.uModel];
        return cell;
    }
    
    XJMyWalletContentTbCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewcontentIdentifier];
    if (cell == nil) {
        cell = [[XJMyWalletContentTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewcontentIdentifier];
    }
    [cell setUpContent:XJUserAboutManageer.uModel];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        [self.navigationController pushViewController:[XJBillRecordVC new] animated:YES];
        
    }
}



#pragma mark lzay
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.backgroundColor = defaultLineColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:self.footerView];
      
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        
        _footerView = [XJUIFactory creatUIViewWithFrame:CGRectMake(0, 0, kScreenWidth, 50) addToView:nil backColor:defaultLineColor];
       
//
    }
    return _footerView;
    
    
}
- (void)phoneAction{
    
    [self showAlerVCtitle:@"提示" message:@"确认拨打电话\n4008-520-272?" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://4008-520-272"]];

    } cancelBlock:^{
        
    }];
    
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
