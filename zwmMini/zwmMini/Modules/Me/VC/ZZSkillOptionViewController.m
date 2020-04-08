//
//  ZZSkillOptionViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSkillOptionViewController.h"
#import "ZZSkillThemesHelper.h"
#import "ZZChooseTagViewController.h"
#import "ZZSignEditViewController.h"
#import "ZZScheduleEditViewController.h"
#import "ZZRegisterRentViewController.h"
#import "XJMyVC.h"
#import "XJEditMyInfoVC.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZChooseSkillViewController.h"
#import "XJTopic.h"
#import "ZZUserEditHeadView.h"
#import "ZZSkillEditCellFooter.h"
#import "ZZSkillOptionFooter.h"
#import "ZZSkillEditBaseCell.h"
#import "ZZSkillEditInputCell.h"
#import "ZZSkillEditTagCell.h"
#import "ZZSkillEditPressCell.h"
#import "ZZSkillEditScheduleCell.h"
#import "ZZSkillEditCellHeader.h"

//#import "kongxia-Swift.h"

@interface ZZSkillOptionViewController () <UITableViewDelegate, UITableViewDataSource, ZZChooseSkillViewControllerDelegate>

@property (nonatomic) UILabel *navTitle;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) ZZSkillEditCellFooter *typeAddFooter;
@property (nonatomic) ZZSkillOptionFooter *typeEditFooter;
@property (nonatomic) ZZUserEditHeadView *skillPhotoHeader;

@property (nonatomic, assign) BOOL isUpdated;   //是否做过修改，是则弹出提示框

@property (nonatomic, assign) BOOL isYidunTimeout;  //易盾检测超时时，标记为嫌疑敏感词

@property (nonatomic, copy) NSArray *currentSkills;

@end

@implementation ZZSkillOptionViewController

- (instancetype)initWithSkillID:(NSString *)skillID {
    self = [super init];
    if (self) {
        [self loadSkill:skillID];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"完善技能介绍";
    _currentSkills = XJUserAboutManageer.uModel.rent.topics;
    [self createNavigationRightDoneBtn];
    [self createView];
}

- (void)createNavigationRightDoneBtn {
    [super createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [self.navigationRightDoneBtn setTitle:@"完成" forState:(UIControlStateHighlighted)];
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)createView {
    [self.view addSubview:self.navTitle];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@20);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navTitle.mas_bottom);
        make.leading.trailing.bottom.equalTo(@0);
    }];
}

- (void)rightBtnClick {
    XJSkill *skill = self.topic.skills[0];
    if ([skill.price integerValue] == 0) {
        [ZZHUD showTastInfoErrorWithString:@"请输入价格"];
        return;
    }
    if ([skill.price integerValue] > 300) {
        [ZZHUD showTastInfoErrorWithString:@"价格不能超过300/小时"];
        return;
    }
    if (self.skillPhotoHeader.isUploading) {
        [ZZHUD showErrorWithStatus:@"请等待图片上传完毕"];
        return;
    }
    [ZZSkillThemesHelper shareInstance].photoUpdate = self.skillPhotoHeader.isUpdate;
    skill.photo = [self.skillPhotoHeader.urlArray copy];
    NSDictionary *params = [self getRequestParams];
    if (self.type == SkillOptionTypeAdd) {
        [self addSkill:params];
    } else {
        [self editSkillById:skill.id params:params];
    }
}

- (NSDictionary *)getRequestParams {    //配置参数
    XJSkill *skill = self.topic.skills[0];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"price":skill.price}];
    //设置主题介绍(有修改才设置)
    if ([ZZSkillThemesHelper shareInstance].introduceUpdate && skill.detail.content) {
        //yidunStatus ：1: "pass"  2:"timeout"
        [params setObject:_isYidunTimeout ? @2 : @1 forKey:@"yidunStatus"];
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
    if (skill.time) {
        [params setObject:skill.time forKey:@"time"];
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
    
    if (self.type != SkillOptionTypeEdit) {
        [params setObject:skill.name forKey:@"name"];
        if (self.type == SkillOptionTypeAdd) {
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
        
        if (!isNullString(skill.name)) {
            [params setObject:skill.name forKey:@"name"];
        }
        
        if (!isNullString(skill.pid)) {
            [params setObject:skill.pid forKey:@"pid"];
        }
    }
    return params;
}

//添加主题技能
- (void)addSkill:(NSDictionary *)params {
 
    [SVProgressHUD show];
    [[ZZSkillThemesHelper shareInstance] addSkill:params next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        [SVProgressHUD dismiss];
        if (data) { //data -- JSON(ZZSkill)
            NSString *price = [NSString stringWithFormat:@"%@",data[@"price"]];
            NSDictionary *topicDict = @{@"price":price,@"skills":@[data]};
            
            XJTopic *topic = [XJTopic yy_modelWithDictionary:topicDict];;
            XJUserModel *user = XJUserAboutManageer.uModel;
            [user.rent.topics addObject:topic];
            XJUserAboutManageer.uModel = user;
            [self showAlert:params];
//
            [self showNotificationAlert:params[@"addType"]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserRentInfoDidChanged object:nil];
        }
    }];
}

//修改主题技能
- (void)editSkillById:(NSString *)skillId params:(NSDictionary *)params {
    [SVProgressHUD show];
    [[ZZSkillThemesHelper shareInstance] editSkillById:skillId params:params next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        [SVProgressHUD dismiss];
        if (data) {
            NSString *price = [NSString stringWithFormat:@"%@",data[@"price"]];
            NSDictionary *topicDict = @{@"price":price,@"skills":@[data]};
            XJTopic *topic = [XJTopic yy_modelWithDictionary:topicDict];;
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
//            [self.navigationController popViewControllerAnimated:YES];
            [self showAlert:params];
//            [self showNotificationAlert:params[@"addType"]];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserRentInfoDidChanged object:nil];
        }
    }];
}

- (void)loadSkill:(NSString *)skillID {
    [[ZZSkillThemesHelper shareInstance] fetchSkillByID:skillID next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            _topic = data;
            XJSkill *skill = self.topic.skills[0];
            _skillPhotoHeader.photos = [NSMutableArray arrayWithArray:skill.photo];
            [_tableView reloadData];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserRentInfoDidChanged object:nil];
    //退出编辑，重置修改标记
    [[ZZSkillThemesHelper shareInstance] resetUpdateSign];
    NSMutableArray *arr = self.navigationController.viewControllers.mutableCopy;
    [arr removeLastObject];
    [arr removeLastObject];
    if ([arr.lastObject isKindOfClass:[ZZChooseSkillViewController class]]) {
        [arr removeLastObject];
    }
    [self.navigationController setViewControllers:arr.copy animated:YES];
//    ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
//    registerRent.type = RentTypeComplete;
//    registerRent.addType = params[@"addType"];
//    [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
//        XJBaseVC *controller;
//        if ([iDict[@"vcname"] isEqualToString:@"XJMyVC"] || [iDict[@"vcname"] isEqualToString:@"ZZSkillThemeManageViewController"]) {
//            for (XJBaseVC *vc in self.navigationController.childViewControllers) {
//                if ([vc isKindOfClass:[ZZSkillThemeManageViewController class]]) {
//                    controller = vc;
//                    break;
//                }
//            }
//            if (controller) {
//                [self.navigationController popToViewController:controller animated:YES];
//            } else {
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//        } else if ([iDict[@"vcname"] isEqualToString:@"XJEditMyInfoVC"]) {
//            for (XJBaseVC *vc in self.navigationController.childViewControllers) {
//                if ([vc isKindOfClass:[XJEditMyInfoVC class]]) {
//                    controller = vc;
//                    break;
//                }
//            }
//            if (controller) {
//                XJEditMyInfoVC *ctl = (XJEditMyInfoVC *)controller;
//                ctl.gotoRootCtl = YES;
//                [self.navigationController popToViewController:ctl animated:YES];
//            } else {
//                XJEditMyInfoVC *controller = [[XJEditMyInfoVC alloc] init];
//                controller.gotoRootCtl = YES;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//        else {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    }];
//    [self.navigationController presentViewController:registerRent animated:YES completion:nil];
}

- (void)deleteThemeClick {
    XJUserModel *loginer = XJUserAboutManageer.uModel;
    if (loginer.rent.topics.count > 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除技能，技能相关的所有内容都会被删除，确认删除？" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self requestDeleteTheme];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"身为达人至少需要一个技能哦，你可以尝试修改技能内容" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)requestDeleteTheme {
    XJSkill *skill = self.topic.skills[0];
    if (skill && skill.id) {
        [[ZZSkillThemesHelper shareInstance] deleteSkillById:skill.id next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
            if (data) { //成功则查找当前ZZUser，删除其中的topic，并保存
                NSInteger deleteIndex = -1;
                XJUserModel *user = XJUserAboutManageer.uModel;
                NSMutableArray *topics = user.rent.topics;
                for (int i = 0; i < topics.count; i++) {
                    XJTopic *topic = topics[i];
                    XJSkill *topicSkill = topic.skills[0];
                    if ([topicSkill.id isEqualToString:skill.id]) {
                        deleteIndex = i;
                        break;
                    }
                }
                if (deleteIndex != -1) {
                    [user.rent.topics removeObjectAtIndex:deleteIndex];
                }
                XJUserAboutManageer.uModel = user;
                //退出编辑，重置修改标记
                [[ZZSkillThemesHelper shareInstance] resetUpdateSign];
                XJBaseVC *popVc;
                for (XJBaseVC *vc in self.navigationController.viewControllers) {
                    if ([[vc class] isEqual:[ZZSkillThemeManageViewController class]]) {
                        popVc = vc;
                        break;
                    }
                }
                if (popVc) {
                    [self.navigationController popToViewController:popVc animated:YES];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [ZZHUD showSuccessWithStatus:@"删除技能成功"];
            }
        }];
    }
}

#pragma mark - ZZChooseSkillViewControllerDelegate
- (void)controller:(ZZChooseSkillViewController *)controller didChooseSkill:(XJSkill *)skill {
    WEAK_SELF()
    XJSkill *currentSkill = self.topic.skills.firstObject;
    if (skill && ![currentSkill.pid isEqualToString:skill.id]) {
        
        __block NSInteger index = -1;
        NSMutableArray *currentSkillArr = _currentSkills.mutableCopy;
        [currentSkillArr enumerateObjectsUsingBlock:^(XJTopic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XJSkill *skill = obj.skills.firstObject;
            if ([currentSkill.pid isEqualToString:skill.pid]) {
                index = idx;
                *stop = YES;
            }
        }];
        
        weakSelf.isUpdated = YES;   //更新修改标记
        [ZZSkillThemesHelper shareInstance].tagUpdate = YES;
        currentSkill.name = skill.name;
        currentSkill.tags = nil;
        currentSkill.pid = skill.id;
        self.topic.skills[0] = currentSkill;
        
        if (index != -1) {
            [currentSkillArr replaceObjectAtIndex:index withObject:self.topic];
        }
        _currentSkills = currentSkillArr.copy;
        [_tableView reloadData];
    }
}


#pragma mark -- tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == SkillOptionTypeAdd && (section == 0 || section == 1)) {
        return 0;   //新建主题不显示标题和价格
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZSkillEditBaseCell *cell = [ZZSkillEditBaseCell dequeueReusableCellForTableView:tableView atIndexPath:indexPath topicModel:self.topic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SkillOptionTypeAdd && (indexPath.section == 0 || indexPath.section == 1)) {    //新建主题不显示标题和价格
        return 0;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_type == SkillOptionTypeEdit && section == 1) {
        ZZSkillEditCellHeader *header = [[ZZSkillEditCellHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        header.backgroundColor = kBGColor;
        [header setTitleText:@"价格"];
        return header;
    }
    if (self.type == SkillOptionTypeAdd && (section == 0 || section == 1)) {    //新建主题不显示标题和价格
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_type == SkillOptionTypeEdit && section == 1) {
        return 35;
    }
    if (self.type == SkillOptionTypeAdd && (section == 0 || section == 1)) {    //新建主题不显示标题和价格
        return 0.1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 10;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XJSkill *skill = self.topic.skills[0];
    WEAK_SELF()
    switch (indexPath.section) {
        case 0: { // 技能
            ZZChooseSkillViewController *allSkills = [[ZZChooseSkillViewController alloc] init];
            allSkills.shouldPopBack = YES;
            allSkills.delegate = self;
            allSkills.choosenArray = _currentSkills;
            allSkills.title = @"选择技能";
            [self.navigationController pushViewController:allSkills animated:YES];
            break;
        }
        case 2: {   //编辑档期
            ZZScheduleEditViewController *controller = [[ZZScheduleEditViewController alloc] init];
            controller.currentTopicModel = self.topic;
            controller.scheduleEditType = self.type == SkillOptionTypeAdd ? ScheduleEditTypeAddSystemTheme : ScheduleEditTypeEditTheme;
            [controller setChooseScheduleCallback:^(NSString *time) {
                weakSelf.isUpdated = YES;   //更新修改标记
                [ZZSkillThemesHelper shareInstance].scheduleUpdate = YES;
                skill.time = time;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            }];
            [self.navigationController pushViewController:controller animated:YES];
        } break;
        case 3: {   //编辑标签
            ZZChooseTagViewController *controller = [[ZZChooseTagViewController alloc] init];
            controller.selectedArray = [skill.tags mutableCopy];
            controller.catalogId = skill.pid ? skill.pid : skill.id;
            [controller setChooseTagCallback:^(NSArray *tags) {
                weakSelf.isUpdated = YES;   //更新修改标记
                [ZZSkillThemesHelper shareInstance].tagUpdate = YES;
                skill.tags = (NSArray<ZZSkillTag> *)tags;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            }];
            [self.navigationController pushViewController:controller animated:YES];
        } break;
        case 4: {   //编辑介绍
            ZZSignEditViewController *controller = [[ZZSignEditViewController alloc] init];
            controller.signEditType = SignEditTypeSkill;
            controller.valueString = skill.detail.content;
            controller.skillName = skill.name;
            controller.skills = skill.tags;
            controller.sid = self.type == SkillOptionTypeAdd ? skill.id : skill.pid;
            //此处传id不传pid，是因为只有添加主题会走到这里，且添加主题时id既是主题的pid
            controller.callBackBlock = ^(NSString *value, BOOL isTimeout, NSInteger errorCode)  {
                weakSelf.isYidunTimeout = isTimeout;
                weakSelf.isUpdated = YES;   //更新修改标记
                [ZZSkillThemesHelper shareInstance].introduceUpdate = YES;
                skill.detail.content = value;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            };
            
            controller.changeSkillsBlock = ^(NSArray<ZZSkillTag *> *skills) {
                XJSkill *skill = _topic.skills[0];
                skill.tags = skills;
                [tableView reloadData];
            };
            [self.navigationController pushViewController:controller animated:YES];
        } break;
        default: break;
    }
}

#pragma mark -- lazy load
- (UILabel *)navTitle {
    if (nil == _navTitle) {
        _navTitle = [[UILabel alloc] init];
        _navTitle.backgroundColor = kYellowColor;
        _navTitle.text = @"完善的技能资料，才能获得首页推荐哦";
        _navTitle.textColor = kBlackColor;
        _navTitle.font = [UIFont systemFontOfSize:12];
        _navTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitle;
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.skillPhotoHeader;
        _tableView.tableFooterView = self.type == SkillOptionTypeAdd ? self.typeAddFooter : self.typeEditFooter;
        [_tableView registerClass:[ZZSkillEditBaseCell class] forCellReuseIdentifier:SkillEditBaseCellId];
        [_tableView registerClass:[ZZSkillEditInputCell class] forCellReuseIdentifier:SkillEditInputCellId];
        [_tableView registerClass:[ZZSkillEditTagCell class] forCellReuseIdentifier:SkillEditTagCellId];
        [_tableView registerClass:[ZZSkillEditPressCell class] forCellReuseIdentifier:SkillEditPressCellId];
        [_tableView registerClass:[ZZSkillEditScheduleCell class] forCellReuseIdentifier:SkillEditScheduleId];
    }
    return _tableView;
}

- (ZZUserEditHeadView *)skillPhotoHeader {
    if (nil == _skillPhotoHeader) {
        WEAK_SELF()
        XJSkill *skill = self.topic.skills[0];
        _skillPhotoHeader = [[ZZUserEditHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _skillPhotoHeader.type = EditTypeSkill;
        _skillPhotoHeader.photos = [NSMutableArray arrayWithArray:skill.photo];
        _skillPhotoHeader.weakCtl = weakSelf;
    }
    return _skillPhotoHeader;
}

- (ZZSkillEditCellFooter *)typeAddFooter {
    if (nil == _typeAddFooter) {
        _typeAddFooter = [[ZZSkillEditCellFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SkillEditCellFooterHeight)];
        _typeAddFooter.stage = 2;
    }
    return _typeAddFooter;
}

- (ZZSkillOptionFooter *)typeEditFooter {
    if (nil == _typeEditFooter) {
        WEAK_SELF()
        _typeEditFooter = [[ZZSkillOptionFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SkillOptionFooterHeight)];
        [_typeEditFooter setSaveBtnClick:^{
            [weakSelf rightBtnClick];
        }];
        [_typeEditFooter setDeleteBtnClick:^{
            [weakSelf deleteThemeClick];
        }];
    }
    return _typeEditFooter;
}

@end
