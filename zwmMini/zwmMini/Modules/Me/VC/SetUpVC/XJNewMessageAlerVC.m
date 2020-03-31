//
//  XJNewMessageAlerVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/30.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJNewMessageAlerVC.h"
#import "XJSetUpSitchTbCell.h"

static NSString *myTableviewIdentifier = @"newmessagesetuptableviewIdentifier";

@interface XJNewMessageAlerVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSArray *titlesArray;

@property(nonatomic, assign)BOOL isPushActive;
@end

@implementation XJNewMessageAlerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPushActive = [XJUtils isAllowNotification];
    self.title = @"新消息提醒";
    self.titlesArray = @[@"推送通知",@"私信"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)applicationBecomeActive {
    BOOL isActive = [XJUtils isAllowNotification];
    if (isActive != _isPushActive) {
        _isPushActive = isActive;
        [_tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    hView.backgroundColor = defaultLineColor;
    return hView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    hView.backgroundColor = defaultLineColor;
   UILabel *exlb = [XJUIFactory creatUILabelWithFrame:CGRectMake(15, 5, kScreenWidth-30, 40) addToView:hView textColor:defaultGray text:@"要开启或关闭推送通知，请在iPhone的“设置”-”通知“中找到伴友进行设置" font:defaultFont(13) textInCenter:NO];
    exlb.numberOfLines = 2;
    
    return hView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJSetUpSitchTbCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
    
    if (cell == nil) {
        cell = [[XJSetUpSitchTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
    }
    if (indexPath.section == 0) {
//        BOOL isOn = [XJUtils isAllowNotification];
        [cell setUpTitle :self.titlesArray[0] isOnSwitch:_isPushActive];
        cell.isNoti = YES;
        cell.block = ^(UISwitch * _Nonnull swi) {
            NSLog(@"%@",swi.isOn ? @"yes":@"no");
            
        };
    }else{
        
        [cell setUpTitle:self.titlesArray[1] isOnSwitch:YES];
        
        cell.block = ^(UISwitch * _Nonnull swi) {
            NSLog(@"%@",swi.isOn ? @"yes":@"no");
        };
    }
    
   
    return cell;
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
