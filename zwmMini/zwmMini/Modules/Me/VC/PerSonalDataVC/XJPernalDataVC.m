//
//  XJPernalDataVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJPernalDataVC.h"
#import "SDCycleScrollView.h"
#import "XJPersonalDataNameTbCell.h"
#import "XJPersonalDetailTbCell.h"
#import "XJPersonalTagsTbCell.h"
#import "XJEditMyInfoVC.h"
#import "XJRentSkillCell.h"
#import "XJTopic.h"
#import "ZZSkillDetailViewController.h"
#import "XJSkill.h"
#import "ZZSkillDetailViewController.h"

@interface XJPernalDataVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,XJEditMyInfoVCDelegate,XJRentSkillCellDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) SDCycleScrollView *headScroView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *editBtn;
@property(nonatomic,strong) UIView *headBgView;
@property(nonatomic,strong) XJPhoto *fistPhoto;

@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UIView *realFaceTipsView;
@property (nonatomic, strong) UILabel *realFaceTipsLabel;//没有真实头像提示

// 1. name 2.info 3.user tag 4.interest
@property(nonatomic,copy) NSArray *cellTypeArray;

@property (nonatomic, copy) NSArray<XJTopic *> *skillsArray;

@end

@implementation XJPernalDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self createSkills];
    [self createCellTypes];
    
    [self loadUserInfo];
}

- (void)loadUserInfo {
    [XJUserModel loadUser:XJUserAboutManageer.uModel.uid param:nil succeed:^(id data, XJRequestError *rError) {
        if (!rError && data) {
            XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data];
            XJUserAboutManageer.uModel = userModel;
        }
        [self createSkills];
        [self createCellTypes];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

- (void)createSkills {
    if (XJUserAboutManageer.uModel.rent.topics.count > 0) {
        NSMutableArray *skillsArr = @[].mutableCopy;
        [XJUserAboutManageer.uModel.rent.topics enumerateObjectsUsingBlock:^(XJTopic * _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
            XJSkill *skill = topic.skills[0];
            if (skill.topicStatus == 2 || skill.topicStatus == 4) {//技能审核状态：0=>审核不通过 1=>待审核 2=>已审核 3=>待确认 4默认通过
                [skillsArr addObject:topic];
            }
        }];
        self.skillsArray = skillsArr.copy;
    }
        
}

- (void)createCellTypes {
    NSMutableArray *cellTypeArray = @[@"1"].mutableCopy;
    // 技能
    if (self.skillsArray.count > 0) {
        [cellTypeArray addObject:@"5"];
    }
    
    [cellTypeArray addObject:@"2"];
    
    if (XJUserAboutManageer.uModel.tags_new && XJUserAboutManageer.uModel.tags_new.count > 0) {
        [cellTypeArray addObject:@"3"];
    }
    if (XJUserAboutManageer.uModel.interests_new && XJUserAboutManageer.uModel.interests_new.count > 0) {
        [cellTypeArray addObject:@"4"];
    }
    _cellTypeArray = cellTypeArray.copy;
}

- (void)creatUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-20);
    }];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.editBtn];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
        make.width.mas_equalTo(345);
        make.height.mas_equalTo(50);
    }];
    self.editBtn.layer.cornerRadius = 25;
    self.editBtn.layer.masksToBounds = YES;
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)edtiAction{
    
    XJEditMyInfoVC *vc = [XJEditMyInfoVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)editCompleet:(BOOL)isComplete {
    [_tableView reloadData];
    _headScroView.imageURLStringsGroup = [self loadImage];
}

- (void)cell:(XJRentSkillCell *)cell selectSkill:(XJTopic *)topic {
    ZZSkillDetailViewController *controller = [[ZZSkillDetailViewController alloc] init];
    controller.user = XJUserAboutManageer.uModel;
    controller.topic = topic;
    controller.isHideBar = NO;
    controller.fromLiveStream = NO;
    controller.type = SkillDetailTypePreview;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark tableviewDelegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XJUserModel *umodel = XJUserAboutManageer.uModel;
    NSString *type = _cellTypeArray[indexPath.row];
    
    if ([type isEqualToString:@"1"]) {
        XJPersonalDataNameTbCell  *cell = [[XJPersonalDataNameTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"namecell"];
        [cell setUpName:umodel.nickname Gender:umodel.gender == 1 ? YES:NO Distance:umodel.distance isOneself:NO];
        return cell;
    }
    else if ([type isEqualToString:@"5"]) {
        // 技能
        XJRentSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"skill"];
        if (!cell) {
            cell = [[XJRentSkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"skill"];
        }
        cell.delegate = self;
        cell.skillsArr = _skillsArray;
        return cell;
    }
    else if ([type isEqualToString:@"2"]) {
        XJPersonalDetailTbCell  *cell = [[XJPersonalDetailTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailcell"];
//        cell.delegate = self;
        [cell setUpPersonalData:umodel isOneself:NO];
        return cell;
    }
    else if ([type isEqualToString:@"3"]) {
        XJPersonalTagsTbCell  *cell = [[XJPersonalTagsTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tagscell"];
        [cell setUpTitle:@"个人标签" Tags:umodel.tags_new];
        return cell;
    }
    else  {
        XJPersonalTagsTbCell  *cell = [[XJPersonalTagsTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"worksscell"];
        [cell setUpTitle:@"兴趣爱好" Tags:umodel.interests_new];
        return cell;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    
}

#pragma mark lzay
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView setTableHeaderView:self.headBgView];
        
        UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
        fview.backgroundColor = defaultWhite;
        [_tableView setTableFooterView:fview];
        _tableView.backgroundColor = defaultLineColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 100.0;
    }
    return _tableView;
}

- (UIView *)headBgView{
    if (!_headBgView) {
        NSArray *phots = XJUserAboutManageer.uModel.photos_origin;
        self.fistPhoto = phots.firstObject;
        CGRect fram = self.fistPhoto.face_detect_status != 3 ?CGRectMake(0, 0, kScreenWidth, kScreenWidth+50):CGRectMake(0, 0, kScreenWidth, kScreenWidth);
        _headBgView = [XJUIFactory creatUIViewWithFrame:fram addToView: nil backColor:defaultWhite];
        [_headBgView addSubview:self.headScroView];
        
        
        self.realFaceTipsView = [[UIView alloc] init];
        self.realFaceTipsView.backgroundColor = UIColor.clearColor;
        [_headBgView addSubview:self.realFaceTipsView];
        
        _realFaceTipsView.frame = CGRectMake(0.0, SafeAreaTopHeight + 15, kScreenWidth, 44.0);
        
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = _realFaceTipsView.bounds;
        visualEffectView.alpha = 0.8;
        [_realFaceTipsView addSubview:visualEffectView];

        
        self.realFaceTipsLabel = [UILabel new];
        self.realFaceTipsLabel.textColor = UIColor.whiteColor;
        self.realFaceTipsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        self.realFaceTipsLabel.numberOfLines = 2;
        self.realFaceTipsLabel.textAlignment = NSTextAlignmentCenter;

        self.faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icProfileBlur"]];
        [_realFaceTipsView addSubview:self.realFaceTipsLabel];
        [_realFaceTipsView addSubview:self.faceImageView];
        
        [_realFaceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_realFaceTipsView);
            make.leading.greaterThanOrEqualTo(@35);
            make.trailing.lessThanOrEqualTo(@(-35));
        }];
        
        [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.realFaceTipsLabel.mas_leading).offset(-5);
            make.top.equalTo(self.realFaceTipsLabel).offset(1);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
        }];
        
        BOOL isShow = NO;
        NSString *icon = @"icTouxiang";//@"icProfileBlur";
//        if ([user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
    
            if ([XJUserAboutManageer.uModel isAvatarManualReviewing]) {
                // 审核中
                if (![XJUserAboutManageer.uModel didHaveOldAvatar]) {
                    isShow = YES;
                    self.realFaceTipsLabel.text = @"头像正在人工审核中，审核通过后正常展示";
                }
            }
            else {
                if (![XJUserAboutManageer.uModel didHaveRealAvatar] && ![XJUserAboutManageer.uModel didHaveOldAvatar]) {
                    isShow = YES;
                    self.realFaceTipsLabel.text = @"您的头像未使用本人正脸五官清晰照片，仅显示一张";
                }
                
            }
//        }
//        else {
//            _attentView.hidden = NO;
//            _editBtn.hidden = YES;
//            if ([user isAvatarManualReviewing]) {
//                // 审核中
//                if (![user didHaveOldAvatar]) {
//                    isShow = YES;
//                    self.realFaceTipsLabel.text = @"头像未使用本人正脸五官清晰照片，仅显示一张";
//                }
//            }
//            else {
//                if (![user didHaveRealAvatar] && ![user didHaveOldAvatar]) {
//                    isShow = YES;
//                    self.realFaceTipsLabel.text = @"头像未使用本人正脸五官清晰照片，仅显示一张";
//                }
//            }
//        }
        
        self.faceImageView.image = [UIImage imageNamed:icon];
        self.realFaceTipsView.hidden = isShow ? NO : YES;
    }
    return _headBgView;
    
    
}

- (NSArray *)loadImage {
    NSMutableArray *tempA = @[].mutableCopy;
    XJPhoto *photo = [[XJPhoto alloc] init];
    if ([XJUserAboutManageer.uModel isAvatarManualReviewing]) {
        photo.url = XJUserAboutManageer.uModel.old_avatar;
        if ([XJUserAboutManageer.uModel didHaveOldAvatar]) {
            tempA = @[XJUserAboutManageer.uModel.old_avatar].mutableCopy;
        }
        else {
            if (XJUserAboutManageer.uModel.photos.count) {
                tempA = @[XJUserAboutManageer.uModel.photos.firstObject.url].mutableCopy;
            }
            else {
                tempA = @[XJUserAboutManageer.uModel.avatar].mutableCopy;
            }
        }
    }
    else {
        [XJUserAboutManageer.uModel.photos enumerateObjectsUsingBlock:^(XJPhoto *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempA addObject: obj.url];
        }];
    }
    return tempA.copy;
}

- (SDCycleScrollView *)headScroView {
    
    if (!_headScroView ) {

        _headScroView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) delegate:self placeholderImage:nil];
        
        _headScroView.imageURLStringsGroup = [self loadImage];
        _headScroView.autoScroll = NO;
        
    }
    return _headScroView;
    
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [XJUIFactory creatUIButtonWithFrame:CGRectMake(0, iPhoneXStatusBarHeight, 44, 44) addToView:self.view backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"whitefanhui" selectImageName:@"whitefanhui" target:self action:@selector(backAction)];
        
    }
    return _backBtn;
    
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:nil backColor:RGB(254, 83, 108) nomalTitle:@"编辑" titleColor:defaultWhite titleFont:defaultFont(17) nomalImageName:nil selectImageName:nil target:self action:@selector(edtiAction)];
    }
    return _editBtn;
}
     

@end
