//
//  XJPrivacyVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJPrivacyVC.h"
#import "XJshieldContacsVC.h"
#import "XJBlackListVC.h"
#import "ZZContactViewController.h"
#import "XJSetUpSitchTbCell.h"
#import "XJNaviVC.h"

static NSString *myTableviewIdentifier = @"privacytableviewIdentifier";

@interface XJPrivacyVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSArray *titlesArray;
@end

@implementation XJPrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私";
    self.titlesArray = @[@"屏蔽手机联系人",@"隐身"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark tableviewDelegate and dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.titlesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titlesArray[indexPath.row];
        cell.textLabel.font = defaultFont(15);
        cell.textLabel.textColor = defaultBlack;
        return cell;
    }else{
        XJSetUpSitchTbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"swithcell"];
        if (cell == nil) {
            cell = [[XJSetUpSitchTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"swithcell"];
        }
        [cell setUpTitle:@"隐身" isOnSwitch:!XJUserAboutManageer.uModel.rent.show];
        cell.block = ^(UISwitch * _Nonnull swi) {
            NSLog(@"%@",swi.isOn ? @"yes":@"no");
            if (swi.isOn) {
                [self showAlerVCtitle:@"确定隐身？" message:@"隐身之后其他人将无法在首页看到你的信息，是否隐身" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{
                    
                    [AskManager POST:API_IS_SHOW_DELETE_POST dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
                        if (!rError) {
                            XJUserModel *oldemodel = XJUserAboutManageer.uModel;
                            oldemodel.rent.show = NO;
                            XJUserAboutManageer.uModel = oldemodel;
                            [MBManager showBriefAlert:@"隐身已开启"];

                        }
                        
                    } failure:^(NSError *error) {
                    }];
                } cancelBlock:^{
                    swi.on = NO;
                }];
                
            }else{
                [AskManager POST:API_IS_SHOW_POST dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
                    if (!rError) {
                        
                        XJUserModel *oldemodel = XJUserAboutManageer.uModel;
                        oldemodel.rent.show = YES;
                        XJUserAboutManageer.uModel = oldemodel;
                        [MBManager showBriefAlert:@"隐身已关闭"];
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
            }
        };
        return cell;
        
    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
//            [self.navigationController pushViewController:[XJshieldContacsVC new] animated:YES];
            XJNaviVC *nav = [[XJNaviVC alloc] initWithRootViewController:[ZZContactViewController new]];
            [self presentViewController:nav animated:YES completion:NULL];
        }
            break;
        case 1:
        {
//            [self.navigationController pushViewController:[XJBlackListVC new] animated:YES];

        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark lzay
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
