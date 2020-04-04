//
//  ZZScheduleEditViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZScheduleEditViewController.h"
#import "ZZScheduleTableHeader.h"
#import "ZZSkillEditCellFooter.h"
#import "ZZScheduleTableCell.h"

#import "XJMyVC.h"
#import "XJEditMyInfoVC.h"
#import "ZZRegisterRentViewController.h"
#import "XJTopic.h"
#import "XJSkill.h"
#import "ZZSkillThemesHelper.h"

@interface ZZScheduleEditViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *scheduleTable;

@property (nonatomic, strong) NSMutableArray *scheduleArray;

@end

@implementation ZZScheduleEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightBarButton];
    [self createView];
}

- (void)createRightBarButton {
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = @"设置档期";
    [self setNavigationRightBtn];
}

- (void)setNavigationRightBtn {     //未选择档期则置灰且不能点击
    [self.navigationRightDoneBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setTitleColor:kBlackColor forState:UIControlStateHighlighted];
    self.navigationRightDoneBtn.userInteractionEnabled = YES;
}

- (void)completeClick {
    NSString *time = [self.scheduleArray componentsJoinedByString:@","];
    if (!time) {
        time = @"";
    }
    !self.chooseScheduleCallback ? : self.chooseScheduleCallback(time);
    [self.navigationController popViewControllerAnimated:YES];
    
//    ZZSkill *skill = self.currentTopicModel.skills[0];
//    NSDictionary *params = [self getRequestParams];
//    if (self.scheduleEditType != ScheduleEditTypeEditTheme) {
//        [self addSkill:params];
//    } else {
//        [self editSkillById:skill.id params:params];
//    }
}
- (NSDictionary *)getRequestParams {
    XJSkill *skill = self.currentTopicModel.skills[0];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"price":skill.price}];
    //设置主题介绍(有修改才设置)
    if ([ZZSkillThemesHelper shareInstance].introduceUpdate && skill.detail.content) {
        [params setObject:skill.detail.content forKey:@"content"];
    }
    //整理图片url(有修改才设置)
    NSMutableArray *photoArray = [NSMutableArray array];
    for (XJPhoto *photo in skill.photo) {
        [photoArray addObject:photo.url];
    }
    NSString *photoStr = photoArray.count > 0 ? [photoArray componentsJoinedByString:@","] : @"";
    if ([ZZSkillThemesHelper shareInstance].photoUpdate && photoStr) {
        [params setObject:photoStr forKey:@"photo"];
    }
    //设置档期参数
    NSString *time = [self.scheduleArray componentsJoinedByString:@","];
    if (time) {
        [params setObject:time forKey:@"time"];
    }
    //设置标签参数(有修改才设置)
    NSMutableArray *tempArray = [NSMutableArray array];
    for (ZZSkillTag *tag in skill.tags) {
        [tempArray addObject:tag.id];
    }
    NSString *tagStr = tempArray.count > 0 ? [tempArray componentsJoinedByString:@","] : @"";
    if ([ZZSkillThemesHelper shareInstance].tagUpdate && tagStr) {
        [params setObject:tagStr forKey:@"tags"];
    }
    //price, content, time, tags, photo -- 添加、修改都包含，添加时都要传，修改时有修改才添加到参数中
    //name, pid, addType -- 添加主题带有参数
    
    if (self.scheduleEditType != ScheduleEditTypeEditTheme) {
        [params setObject:skill.name forKey:@"name"];
        if (self.scheduleEditType == ScheduleEditTypeAddSystemTheme) {
            [params setObject:skill.id forKey:@"pid"];
        } else {
            [params setObject:@"" forKey:@"pid"];
        }
        XJUserModel *user = XJUserAboutManageer.uModel;
        if (user.rent.status != 0) {
            [params setObject:@"add" forKey:@"addType"];
        } else {
            [params setObject:@"apply" forKey:@"addType"];
        }
    } else {    //编辑主题要传addtype ‘edit’
        [params setObject:@"edit" forKey:@"addType"];
    }
    return params;
}

- (void)setCurrentTopicModel:(XJTopic *)currentTopicModel {
    _currentTopicModel = currentTopicModel;
    XJSkill *skill = currentTopicModel.skills[0];
    if (skill.time) {
        NSArray *schedule = !isNullString(skill.time) ? [skill.time componentsSeparatedByString:@","] : @[];
        self.scheduleArray = [NSMutableArray arrayWithArray:schedule];
    }
}

//添加主题技能
- (void)addSkill:(NSDictionary *)params {
    [[ZZSkillThemesHelper shareInstance] addSkill:params next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (data) { //data -- JSON(ZZSkill)
            NSString *price = [NSString stringWithFormat:@"%@",data[@"price"]];
            NSDictionary *topicDict = @{@"price":price,@"skills":@[data]};
            XJTopic *topic = [XJTopic yy_modelWithDictionary:topicDict];
            XJUserModel *user = XJUserAboutManageer.uModel;
            [user.rent.topics addObject:topic];
            XJUserAboutManageer.uModel = user;
            [self showAlert:params];
            [self showNotificationAlert:params[@"addType"]];
        }
    }];
}
//修改主题技能
- (void)editSkillById:(NSString *)skillId params:(NSDictionary *)params {
    [[ZZSkillThemesHelper shareInstance] editSkillById:skillId params:params next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            NSString *price = [NSString stringWithFormat:@"%@",data[@"price"]];
            NSDictionary *topicDict = @{@"price":price,@"skills":@[data]};
            XJTopic *topic = [XJTopic yy_modelWithDictionary:topicDict];
            XJUserModel *user = XJUserAboutManageer.uModel;
            for (int i = 0; i < user.rent.topics.count; i++) {      //查询ZZUser的topics，id匹配则替换
                XJTopic *userTopic = user.rent.topics[i];
                XJSkill *skill = userTopic.skills[0];
                if ([skill.id isEqualToString:data[@"id"]]) {
                    [user.rent.topics replaceObjectAtIndex:i withObject:topic];
                    XJUserAboutManageer.uModel = user;
                    break;
                }
            }
            [self showAlert:params];
            [self showNotificationAlert:params[@"addType"]];
        }
    }];
}

- (void)showNotificationAlert:(NSString *)firstRegisterRent { //首次开通闪租，未打开推送时，返回‘我的’提示打开推送
    if ([firstRegisterRent isEqualToString:@"apply"]) {   //首次开通
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            [ZZUserDefaultsHelper setObject:@(YES) forDestKey:@"CloseNotificationWhenFirstRegisterRent"];
        }
    }
}

- (void)showAlert:(NSDictionary *)params {
    //退出编辑，重置修改标记
    [[ZZSkillThemesHelper shareInstance] resetUpdateSign];
    
    ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
    registerRent.type = RentTypeComplete;
    registerRent.addType = params[@"addType"];
    [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
        XJBaseVC *controller;
        if ([iDict[@"vcname"] isEqualToString:@"XJMyVC"]) {
            for (XJBaseVC *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[XJMyVC class]]) {
                    controller = vc;
                    break;
                }
            }
            if (controller) {
                [self.navigationController popToViewController:controller animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } else if ([iDict[@"vcname"] isEqualToString:@"XJEditMyInfoVC"]) {
            for (XJBaseVC *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[XJEditMyInfoVC class]]) {
                    controller = vc;
                    break;
                }
            }
            if (controller) {
                XJEditMyInfoVC *ctl = (XJEditMyInfoVC *)controller;
                ctl.gotoRootCtl = YES;
                [self.navigationController popToViewController:ctl animated:YES];
            } else {
                XJEditMyInfoVC *controller = [[XJEditMyInfoVC alloc] init];
                controller.gotoRootCtl = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }];
    [self.navigationController presentViewController:registerRent animated:YES completion:nil];
}

- (void)createView {
    [self.view addSubview:self.scheduleTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF()
    ZZScheduleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ScheduleTableCellIdentifier forIndexPath:indexPath];
    cell.scheduleArray = self.scheduleArray;
    [cell setChooseCallback:^{
        [weakSelf setNavigationRightBtn];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ScheduleTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZZScheduleTableHeader *header = [[ZZScheduleTableHeader alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ScheduleTableHeaderHeight)];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- lazy load
- (UITableView *)scheduleTable {
    if (nil == _scheduleTable) {
        _scheduleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStyleGrouped)];
        _scheduleTable.delegate = self;
        _scheduleTable.dataSource = self;
        _scheduleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_scheduleTable registerClass:[ZZScheduleTableCell class] forCellReuseIdentifier:ScheduleTableCellIdentifier];
    }
    return _scheduleTable;
}
- (NSMutableArray *)scheduleArray {
    if (nil == _scheduleArray) {
        _scheduleArray = [NSMutableArray array];
    }
    return _scheduleArray;
}

@end
