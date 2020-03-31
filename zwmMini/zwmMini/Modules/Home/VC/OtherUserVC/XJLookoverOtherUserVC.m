//
//  XJLookoverOtherUserVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJLookoverOtherUserVC.h"
#import "SDCycleScrollView.h"
#import "XJPersonalDataNameTbCell.h"
#import "XJPersonalDetailTbCell.h"
#import "XJPersonalTagsTbCell.h"
#import "XJLookWxPayCoinVC.h"
#import "XJNaviVC.h"
#import "XJLookWxEnougCoinVC.h"
#import "XJNoEvaluateVC.h"
#import "XJChatViewController.h"
#import "XJLoginVC.h"
#import "XJReportVC.h"
#import "ZZUpdateAlertView.h"


@interface XJLookoverOtherUserVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,XJPersonalDetailTbCellDelegate>


@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) SDCycleScrollView *headScroView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *priLetterBtn;
@property(nonatomic,strong) UIButton *lookwxBtn;
@property(nonatomic,strong) XJUserModel *lookuserModel;
@property(nonatomic,strong) UIImageView *topgrayIV;
@property(nonatomic,strong) UIButton *reportBtn;
@property(nonatomic,strong) UIView *headBgView;
@property(nonatomic,strong) XJPhoto *fistPhoto;

// 1. name 2.info 3.user tag 4.interest
@property(nonatomic,copy) NSArray *cellTypeArray;

@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UIView *realFaceTipsView;
@property (nonatomic, strong) UILabel *realFaceTipsLabel;//没有真实头像提示

@end

@implementation XJLookoverOtherUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self getLookUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:reloadLookOtherInfo object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!XJUserAboutManageer.shouldChangeAppTips) {
        return;
    }
    
    [AskManager GET:@"api/system/ybyUpApp"
               dict:@{}.mutableCopy
            succeed:^(id data, XJRequestError *rError) {
        if (!rError && (!data && [data count] != 0)) {
            XJUserAboutManageer.shouldChangeAppTips = NO;
            ZZUpdateAlertView *alertView = [[ZZUpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) upgradeTips:data];
            [self.view.window addSubview:alertView];
        }
    }
            failure:^(NSError *error) {
    }];
}

//购买成功刷新数据
- (void)reloadData{
    [self getLookUserInfo];
}

- (void)creatUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(-20);
    }];
    [self.view addSubview:self.topgrayIV];
    [self.topgrayIV addSubview:self.backBtn];
    [self.topgrayIV addSubview:self.reportBtn];
    
    [self.view addSubview:self.priLetterBtn];
    [self.view addSubview:self.lookwxBtn];
    [self.priLetterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-38);
        make.right.equalTo(self.view.mas_centerX).offset(-8);
        make.width.mas_equalTo(164);
        make.height.mas_equalTo(64);
    }];
    [self.lookwxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-38);
        make.left.equalTo(self.view.mas_centerX).offset(8);
        make.width.mas_equalTo(164);
        make.height.mas_equalTo(64);
    }];
    
    
}

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)reportAction{
    
    NSLog(@"举报");
    if (!XJUserAboutManageer.isLogin) {
        [XJUserAboutManageer managerRemoveUserInfo];
        [[XJRongIMManager sharedInstance] logOutRongIM];
        XJLoginVC *loginV = [[XJLoginVC alloc] init];
        [self.navigationController pushViewController:loginV animated:YES];
        return;
    }
    XJReportVC *reVC = [XJReportVC new];
    reVC.uid = self.lookuserModel.uid;
    [self.navigationController pushViewController:reVC animated:YES];
}

- (void)getLookUserInfo{
    
    NSString *url = XJUserAboutManageer.isLogin ? [NSString stringWithFormat:@"%@/%@",API_GET_USERINFO_LIST,self.topUserModel.uid] :[NSString stringWithFormat:@"%@/%@/detail",API_GET__UNLOGIN_USERINFO_LIST,self.topUserModel.uid];
    
    [AskManager GET:url dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        self.lookuserModel = [XJUserModel yy_modelWithDictionary:data];
        NSMutableArray *cellTypeArray = @[@"1", @"2"].mutableCopy;
        if (self.lookuserModel.tags_new && self.lookuserModel.tags_new.count > 0) {
            [cellTypeArray addObject:@"3"];
        }
        if (self.lookuserModel.interests_new && self.lookuserModel.interests_new.count > 0) {
            [cellTypeArray addObject:@"4"];
        }
        self.cellTypeArray = cellTypeArray.copy;
        
        [self.tableView reloadData];
        [self setUpbottonBtnType];
        NSMutableArray *tempA = @[].mutableCopy;

        
        XJPhoto *photo = [[XJPhoto alloc] init];
        if ([self.lookuserModel isAvatarManualReviewing] ) {
            photo.url = self.lookuserModel.old_avatar;
            if ([self.lookuserModel didHaveOldAvatar]) {
                tempA = @[self.lookuserModel.old_avatar].mutableCopy;
            }
            else {
                if (self.lookuserModel.photos.count) {
                    tempA = @[self.lookuserModel.photos.firstObject.url].mutableCopy;
                }
                else {
                    tempA = @[self.lookuserModel.avatar].mutableCopy;
                }
            }
        }
        else {
            [self.lookuserModel.photos enumerateObjectsUsingBlock:^(XJPhoto *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempA addObject: obj.url];
            }];
        }
        
        self.headScroView.imageURLStringsGroup = (NSArray *)tempA;
        
        //没有微信隐藏查看微信按钮
        if (!self.lookuserModel.have_wechat_no) {
            self.lookwxBtn.hidden = YES;
            [self.priLetterBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-38);
                make.centerX.equalTo(self.view);
                make.width.mas_equalTo(340);
                make.height.mas_equalTo(64);
            }];
            [self.priLetterBtn setBackgroundImage:GetImage(@"sixinbtnimgy") forState:UIControlStateNormal];
        }
        
        [self showUserFaceTips];
        
    } failure:^(NSError *error) {
        
    }];
}

//个人详情的微信
- (void)clickLookoverWxBtn{
    NSLog(@"detail查看微信");
    if (XJUserAboutManageer.isLogin) {
        [self lookoverWx];

    }else{
        [self.navigationController pushViewController:[XJLoginVC new] animated:YES];
    }
}
//私信
- (void)priLetterAction{
    NSLog(@"私信");
    if (XJUserAboutManageer.isLogin) {
        if ([XJUserAboutManageer isUserBanned]) {
            return;
        }
        XJChatViewController *conversationVC = [[XJChatViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = self.lookuserModel.uid;
        conversationVC.title = self.lookuserModel.nickname;
        [self getRechargeInfo:self.lookuserModel.uid pushController:conversationVC];
//        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    else {
        [self.navigationController pushViewController:[XJLoginVC new] animated:YES];
    }
}

- (void)getRechargeInfo:(NSString *)targetid pushController:(XJChatViewController *)controller{
    [MBManager showLoading];
    @WeakObj(self);
    [AskManager GET:API_MESSAGE_ISCHARGE_(targetid) dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError){
        @StrongObj(self);
        if (!rError) {
            BOOL isNeedCharge = [data[@"open_charge"] boolValue];
            controller.isNeedCharge = isNeedCharge;
            [self.navigationController pushViewController:controller animated:YES];
        }
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        [MBManager hideAlert];
    }];
}

//底部查看微信
- (void)lookwxAction{
    [self lookoverWx];
}

//设置查看微信按钮图片
- (void)setUpbottonBtnType{
    
    //已查看微信
    if (self.lookuserModel.can_see_wechat_no) {
        //已评价
        if (self.lookuserModel.have_commented_wechat_no) {
            
            [self.lookwxBtn setBackgroundImage:GetImage(@"yipingjiaimg") forState:UIControlStateNormal];
            
            //未评价
        }else{
            [self.lookwxBtn setBackgroundImage:GetImage(@"pingjiaimg") forState:UIControlStateNormal];
        }
        
        //未查看微信
    }else{
        [self.lookwxBtn setBackgroundImage:GetImage(@"lookwximg") forState:UIControlStateNormal];
    }
}

- (void)lookoverWx{
    if (!XJUserAboutManageer.isLogin) {
        XJLoginVC *loginV = [[XJLoginVC alloc] init];
        [self.navigationController pushViewController:loginV animated:YES];
        return;
    }
    if (!self.lookuserModel.have_wechat_no) {
        [MBManager showBriefAlert:@"该用户为未填写微信号"];
        return;
    }
    //已查看微信
    if (self.lookuserModel.can_see_wechat_no) {
        
        //已评价
        if (self.lookuserModel.have_commented_wechat_no) {
            
            XJNoEvaluateVC *noValuatVC = [XJNoEvaluateVC new];
            noValuatVC.userModel = self.lookuserModel;
            noValuatVC.isEvaluate = YES;
            self.definesPresentationContext = YES;
            noValuatVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:noValuatVC animated:YES completion:nil];
            
            
            //未评价微信号去评价
        }else{
            
            XJNoEvaluateVC *noValuatVC = [XJNoEvaluateVC new];
            noValuatVC.userModel = self.lookuserModel;
            noValuatVC.isEvaluate = NO;
            self.definesPresentationContext = YES;
            noValuatVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:noValuatVC animated:YES completion:nil];
            
        }
        
        //未查看微信 去查看
    }else{
        
        //余额不足去购买
        if (XJUserAboutManageer.uModel.mcoin < self.lookuserModel.wechat_price_mcoin ) {
            
            XJLookWxPayCoinVC *coinVC = [XJLookWxPayCoinVC new];
            coinVC.userModel = self.lookuserModel;
            self.definesPresentationContext = YES;
            coinVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:coinVC animated:YES completion:nil];
            @WeakObj(self);
            coinVC.successBlcok = ^(NSString * _Nonnull coinstr) {
                @StrongObj(self);
                NSLog(@"充值成功就购买");
                //余额还是不足
                if ([coinstr integerValue] < self.lookuserModel.wechat_price_mcoin ) {
                    
                    [self lookoverWx];
                    
                }else{
                    [self buyCoinSuccess];

                }
            };
            
        //余额充足去查看
        }else{
            
            XJLookWxEnougCoinVC *enoughVC = [XJLookWxEnougCoinVC new];
            enoughVC.userModel = self.lookuserModel;
            self.definesPresentationContext = YES;
            enoughVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:enoughVC animated:YES completion:nil];
            
        }
        
    }
    
}

//充值成功购买微信
- (void)buyCoinSuccess{
    
    [MBManager showBriefAlert:@"查看中..."];
    [AskManager POST:API_BUY_WX_WITH_(self.lookuserModel.uid) dict:@{@"price":@(self.lookuserModel.wechat_price_mcoin),@"channel":@"pay_for_wechat"}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        //购买成功去刷新页面
        if (!rError) {
            
            //            NSLog(@"%@",data);
            [MBManager showBriefAlert:@"查看成功"];
            [self getLookUserInfo];
           
        }
        
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];
        
    }];
    
    
}

- (void)showUserFaceTips {
    BOOL isShow = NO;
    NSString *icon = @"icTouxiang";//@"icProfileBlur";
    if ([_lookuserModel isAvatarManualReviewing]) {
        // 审核中
        if (![_lookuserModel didHaveOldAvatar]) {
            isShow = YES;
            self.realFaceTipsLabel.text = @"头像未使用本人正脸五官清晰照片，仅显示一张";
        }
    }
    else {
        if (![_lookuserModel didHaveRealAvatar] && ![_lookuserModel didHaveOldAvatar]) {
            isShow = YES;
            self.realFaceTipsLabel.text = @"头像未使用本人正脸五官清晰照片，仅显示一张";
        }
    }
    
    self.faceImageView.image = [UIImage imageNamed:icon];
    self.realFaceTipsView.hidden = isShow ? NO : YES;
}

#pragma mark tableviewDelegate and dataSource
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    switch (indexPath.row) {
//        case 0:
//        {
//            return 119.f;
//        }
//            break;
//        case 1:
//        {
//            CGFloat strheight = NULLString(self.lookuserModel.bio) ? 20.f : [XJUtils heightForCellWithText:self.lookuserModel.bio fontSize:15.f labelWidth:kScreenWidth-70];
//            CGFloat height = 382 +  strheight;
//            return height;
//        }
//            break;
//        case 2:
//        {
//
//            CGFloat height =  [XJUtils countTagsViewHeight:self.lookuserModel.tags_new]*54+71;
//
//            return height;
//
//        }
//            break;
//        case 3:
//        {
//            CGFloat height =  [XJUtils countTagsViewHeight:self.lookuserModel.interests_new]*54+71;
//
//            return height;
//        }
//            break;
//
//        default:
//
//            break;
//    }
//    return 0.f;
//
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTypeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJUserModel *umodel = self.lookuserModel;
    NSString *type = _cellTypeArray[indexPath.row];
    
    if ([type isEqualToString:@"1"]) {
        XJPersonalDataNameTbCell  *cell = [[XJPersonalDataNameTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"namecell"];
        [cell setUpName:umodel.nickname Gender:umodel.gender == 1 ? YES:NO Distance:umodel.distance isOneself:NO];
        return cell;
    }
    else if ([type isEqualToString:@"2"]) {
        XJPersonalDetailTbCell  *cell = [[XJPersonalDetailTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailcell"];
        cell.delegate = self;
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
           self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        _tableView.estimatedRowHeight = 100.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    return _tableView;
}
- (UIView *)headBgView{
    if (!_headBgView) {
        _headBgView = [XJUIFactory creatUIViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) addToView: nil backColor:defaultWhite];
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
        
        [self showUserFaceTips];
    }
    return _headBgView;
    
    
}
- (SDCycleScrollView *)headScroView{
    
    if (!_headScroView ) {
        
        _headScroView =  [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) delegate:self placeholderImage:nil];
//        _headScroView.imageURLStringsGroup = @[];
        _headScroView.autoScroll = NO;
        
        
    }
    return _headScroView;
    
}
- (UIImageView *)topgrayIV{
    if (!_topgrayIV) {
        _topgrayIV = [XJUIFactory creatUIImageViewWithFrame:CGRectMake(0, 0, kScreenWidth, SafeAreaTopHeight) addToView:nil imageUrl:nil placehoderImage:@"personaldetailtopimg"];
        _topgrayIV.userInteractionEnabled = YES;
    }
    return _topgrayIV;
    
}
- (UIButton *)reportBtn{
    if (!_reportBtn) {
        _reportBtn = [XJUIFactory creatUIButtonWithFrame:CGRectMake(kScreenWidth-50, iPhoneXStatusBarHeight, 50, 44) addToView:nil backColor:defaultClearColor nomalTitle:@"举报" titleColor:defaultWhite titleFont:defaultFont(15) nomalImageName:nil selectImageName:nil target:self action:@selector(reportAction)];
    }
    return _reportBtn;
    
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [XJUIFactory creatUIButtonWithFrame:CGRectMake(0, iPhoneXStatusBarHeight, 44, 44) addToView:nil backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"whitefanhui" selectImageName:@"whitefanhui" target:self action:@selector(backAction)];
        
    }
    return _backBtn;
    
}

- (UIButton *)priLetterBtn{
    if (!_priLetterBtn) {
        _priLetterBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:nil backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"" selectImageName:@"" target:self action:@selector(priLetterAction)];
        [_priLetterBtn setBackgroundImage:GetImage(@"priletterimg") forState:UIControlStateNormal];
        
    }
    return _priLetterBtn;
    
}
- (UIButton *)lookwxBtn{
    if (!_lookwxBtn) {
        _lookwxBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:nil backColor:defaultClearColor nomalTitle:@"" titleColor:nil titleFont:nil nomalImageName:@"" selectImageName:@"" target:self action:@selector(lookwxAction)];
       
    }
    return _lookwxBtn;
    
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
