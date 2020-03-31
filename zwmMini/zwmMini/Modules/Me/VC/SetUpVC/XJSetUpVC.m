//
//  XJSetUpVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSetUpVC.h"
#import "XJSetUpTableViewCell.h"
#import "XJAccountAndSafeVC.h"
#import "XJJourneySafeVC.h"
#import "XJNewMessageAlerVC.h"
#import "XJPrivacyVC.h"
#import "XJAboutBanyouVC.h"
#import "XJHelpAndBackVC.h"
#import "XJCommonUseVC.h"
#import "XJdisclaimerVC.h"
#import "XJTabBarVC.h"
static NSString *myTableviewIdentifier = @"mysetuptableviewIdentifier";

@interface XJSetUpVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSArray *titlesArray;
@property(nonatomic,strong) UIButton *logoutBtn;
@property(nonatomic,assign) CGFloat cachfloat;

@end

@implementation XJSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.cachfloat = [XJUtils getCachSize];
    [self creatUI];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)creatUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
        make.height.mas_equalTo(60);
    }];
}


//退出登录
- (void)logoutAction{
    [self showAlerVCtitle:@"确定要退出吗" message:@"" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{
        [XJUserAboutManageer managerRemoveUserInfo];
        [[XJRongIMManager sharedInstance] logOutRongIM];
//        self.tabBarController.selectedIndex = 0;
//        [self.navigationController popToRootViewControllerAnimated:YES];
        ([UIApplication sharedApplication].delegate).window.rootViewController = [[XJTabBarVC alloc] init];

    }  cancelBlock:^{
        
    }];
}




#pragma mark tableviewDelegate and dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return [self.titlesArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    hView.backgroundColor = defaultLineColor;
    return hView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 7.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJSetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
    
    if (cell == nil) {
        cell = [[XJSetUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
    }
    if (indexPath.section != 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setUpTitle:self.titlesArray[indexPath.section][indexPath.row] andCach:self.cachfloat withIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0://账号和安全
                {
                
                    [self.navigationController pushViewController:[XJAccountAndSafeVC new] animated:YES];
                    
                }
                    break;
                case 1://行程安全
                {
                    [self.navigationController pushViewController:[XJJourneySafeVC new] animated:YES];
      
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0://新消息提醒
                {
                    [self.navigationController pushViewController:[XJNewMessageAlerVC new] animated:YES];

                
                    
                }
                    break;
                case 1://隐私
                {
                    
                    [self.navigationController pushViewController:[XJPrivacyVC new] animated:YES];

                    
                }
                    break;
                case 2://通用
                {
                    [self.navigationController pushViewController:[XJCommonUseVC new] animated:YES];

                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0://关于伴友
                {
                    
                    [self.navigationController pushViewController:[XJAboutBanyouVC new] animated:YES];

                    
                }
                    break;
                case 1://帮助和反馈
                {
                    
                    [self.navigationController pushViewController:[XJdisclaimerVC new] animated:YES];

                    
//                    [self.navigationController pushViewController:[XJHelpAndBackVC new] animated:YES];

                }
                    break;
                case 2://免责声明
                {
                    
                    [self.navigationController pushViewController:[XJdisclaimerVC new] animated:YES];

                    
                }
                    break;
                case 3://应用评分
                {
                    
                    
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 3:
        {
            [self showAlerVCtitle:@"是否清除缓存？" message:@"" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{
                
                [XJUtils handleClearCach];
                self.cachfloat = 0.f;
                [self.tableView reloadData];
                
            }  cancelBlock:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.backgroundColor = defaultLineColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
}

- (UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.view backColor:defaultRedColor nomalTitle:@"退出登录" titleColor:defaultWhite titleFont:defaultFont(18) nomalImageName:nil selectImageName:nil target:self action:@selector(logoutAction)];
    }
    return _logoutBtn;
    
}
- (NSArray *)titlesArray{
    
    if (!_titlesArray) {
        
        _titlesArray = @[@[@"账号和安全"],@[@"新消息提醒",@"隐私",@"通用"],@[@"关于租我吗",@"免责声明"],@[@"清除缓存"]];
    }
    return _titlesArray;
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
