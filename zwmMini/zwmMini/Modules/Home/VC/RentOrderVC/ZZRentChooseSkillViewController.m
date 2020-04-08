//
//  ZZRentChooseSkillViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentChooseSkillViewController.h"
#import "ZZRentOrderInfoViewController.h"

#import "ZZRentChooseSkillCell.h"
#import "ZZDateHelper.h"
#import "XJTopic.h"
#import "XJSkill.h"

@interface ZZRentChooseSkillViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView                     *_tableView;
}

@end

@implementation ZZRentChooseSkillViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"选择技能";
    
    [self createLeftButton];
    [self createViews];
    [self loadData];
}

- (void)createLeftButton
{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    if (_isEdit) {
        [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];

}

- (void)navigationLeftBtnClick
{
    if (_isEdit) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBGColor;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - Data
- (void)loadData {
    if (!_user) {
        NSString *uid = @"";
        if (_order) {
            if ([XJUserAboutManageer.uModel.uid isEqualToString:_order.to.uid]) {
                uid = _order.from.uid;
            } else {
                uid = _order.to.uid;
            }
        }
        else {
            uid = _uid;
        }
        
        [XJUserModel loadUser:uid param:nil succeed:^(id data, XJRequestError *rError) {
            if (!rError && data) {
                XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data];
                self.user = userModel;
                [self reload];
            }
            
        } failure:^(NSError *error) {
            if (error) {
                [MBManager showBriefAlert:error.localizedDescription];
            }
        }];
    }
    else {
        [self reload];
    }
}

- (void)reload {
    [_tableView reloadData];
    
    NSInteger section = 0;
    NSInteger row = 0;
    BOOL searched = NO;
    
    for (XJTopic *topic in _user.rent.topics) {
        for (XJSkill *skill in topic.skills) {
            if ([skill.name isEqualToString:_order.skill.name]) {
                searched = YES;
                break;
            }
        }
        if (searched) {
            break;
        }
    }
//    if (_user.rent.topics.count>0) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//        [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _user.rent.topics.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XJTopic *topic = _user.rent.topics[section];
    return topic.skills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"mycell";
    
    ZZRentChooseSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZRentChooseSkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XJTopic *topic = _user.rent.topics[indexPath.section];
    XJSkill *skill = topic.skills[indexPath.row];
    cell.titleLabel.text = skill.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor = kBGColor;
    
    XJTopic *topic = _user.rent.topics[section];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = kGrayTextColor;
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"%@元/小时", topic.price];
    [headView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left).offset(15);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      __weak typeof(self) Weakself = self;;
    ZZRentOrderInfoViewController *vc = [[ZZRentOrderInfoViewController alloc] init];
    vc.isEdit = _isEdit;
    vc.fromChat = _fromChat;
    XJTopic *topic = _user.rent.topics[indexPath.section];
    XJSkill *skill = topic.skills[indexPath.row];
    if (!_order) {
        _order = [[ZZOrder alloc] init];
        _order.dated_at_type = 1;
        _order.dated_at = [[ZZDateHelper shareInstance] getNextHours:4];
        _order.from = XJUserAboutManageer.uModel;
    }

    // 查看微信价格
    _order.wechat_service = (_order.wechat_service || (XJUserAboutManageer.sysCofigModel.order_wechat_enable && _user.have_wechat_no && !_user.can_see_wechat_no));

    _order.wechat_price = _order.wechat_service ? XJUserAboutManageer.sysCofigModel.order_wechat_price : 0;

    _order.price = [NSNumber numberWithDouble:[topic.price doubleValue]];

    _order.skill = skill;
    _order.city = _user.rent.city;
    _order.to = [XJUserModel yy_modelWithDictionary:@{@"uid":_user.uid}]; //[[ZZUser alloc] initWithDictionary:@{@"uid":_user.uid} error:nil];;
    vc.order = _order;
    vc.user = _user;
    vc.callBack = ^{
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Navigation

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
