//
//  XJMyVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyVC.h"
#import "XJLoginVC.h"
#import "XJMyHeadView.h"
#import "XJMyTableViewCell.h"
#import "XJMyHeadView.h"
#import "XJMyWalletVC.h"
#import "XJMywechatVC.h"
#import "XJBeReviewWechatVC.h"
#import "XJHasReviewWechatVC.h"
#import "XJRealNameAutoVC.h"
#import "XJEditMyInfoVC.h"
#import "XJPernalDataVC.h"
#import "XJSetUpVC.h"
#import "XJCheckingFaceVC.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "XJUploadRealHeadImgVC.h"
#import "ZZUserCenterOrderCell.h"
#import "ZZOrderListViewController.h"
#import "ZZUserCenterRentGuideCell.h"
#import "ZZUserCenterRespondCell.h"
#import "ZZUserStatisDataViewController.h"
#import "ZZKeyValueStore.h"
#import "ZZRentalAgreementVC.h"
#import "ZZRegisterRentViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZUserCenterBaseCell.h"

static NSString *myTableviewIdentifier = @"mytableviewIdentifier";
static NSString *myTableviewIdentifierr = @"mytableviewIdentifierr";
@interface XJMyVC ()<UITableViewDelegate,UITableViewDataSource,XJMyHeadViewDelegate, XJEditMyInfoVCDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) XJMyHeadView *headView;
@property(nonatomic,copy) NSArray *titlesArray;
@property(nonatomic,copy) NSArray *imgsArray;
@property(nonatomic,assign) NSInteger selecttype;//0 设置微信号 1实名认证 3出租

@property(nonatomic,assign) BOOL shouldRefresh;

@property (nonatomic, assign) BOOL hideChuzuRedPoint;

@end

@implementation XJMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = defaultWhite;
    [self showNavRightButton:@"" action:@selector(rightAction) image:GetImage(@"myset") imageOn:GetImage(@"myset")];
    [self creatUI];
    _shouldRefresh = NO;
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [XJUserModel loadUser:XJUserAboutManageer.uModel.uid param:nil];
}

- (void)creatUI {
    [self.view addSubview:self.tableView];
    if (XJUserAboutManageer.uModel) {
        [self.headView setUpHeadViewInfo:XJUserAboutManageer.uModel];
    }
}

/**
我的档期
 */
- (void)gotoOrderWithIndex:(NSInteger)index {
    OrderListType _type = OrderListTypeAll;
    switch (index) {
        case 0: {
            _type = OrderListTypeIng;
        } break;
        case 1: {
            _type = OrderListTypeComment;
        } break;
        case 2: {
            _type = OrderListTypeDone;
        } break;
        default: {
            _type = OrderListTypeAll;
        } break;
    }
    ZZOrderListViewController *controller = [[ZZOrderListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.type = _type;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)manageRedView {
    _hideChuzuRedPoint = YES;
    if (XJUserAboutManageer.uModel.rent.status != 2 && !XJUserAboutManageer.userFirstRent) {
        _hideChuzuRedPoint = NO;
    }
    [_tableView reloadData];
}

- (void)clickHeadIV {
    if ([XJUserAboutManageer isUserBanned]) {
        //        [MBManager showBriefAlert:@"您已被封禁"];
        return;
    }
    [self.navigationController pushViewController:[XJPernalDataVC new] animated:YES];
}

- (void)editCompleet:(BOOL)isComplete {
//    _shouldRefresh = YES;
}

- (void)editPersonalData{
    if ([XJUserAboutManageer isUserBanned]) {
        [MBManager showBriefAlert:@"您已被封禁"];
        return;
    }
    XJEditMyInfoVC *vc =  [[XJEditMyInfoVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)rightAction {
    [self.navigationController pushViewController:[XJSetUpVC new] animated:YES];
    
}

#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 || indexPath.section == 1)) {
        if (indexPath.row == 1) {
            return 76;
        }
        return 56;
    }
    return 65.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 2 : self.imgsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            XJMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifierr];
            
            if (cell == nil) {
                cell = [[XJMyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifierr];
            }
            [cell setUpIndexPath:indexPath Imge:nil Title:@"我的档期"];
            return cell;
        }
        else {
            ZZUserCenterOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordercell"];
            cell.selectOrder = ^(NSInteger index) {
                [self gotoOrderWithIndex:index];
            };
            [cell setData];
            return cell;
        }
    }
//    else if (indexPath.section == 1) {
//        if (indexPath.row == 1) {
//            if (XJUserAboutManageer.uModel.rent.status == 0 || XJUserAboutManageer.uModel.banStatus) {
//                ZZUserCenterRentGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZUserCenterRentGuideCell"];
//                return cell;
//            } else {
//                ZZUserCenterRespondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZUserCenterRespondCell"];
//                [cell setData:XJUserAboutManageer.uModel];
//                return cell;
//            }
//        }
//        else {
//            ZZUserCenterBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZUserCenterBaseCell"];
//            [cell setData:XJUserAboutManageer.uModel indexPath:indexPath hideRedPoint:_hideChuzuRedPoint];
//            return cell;
//        }
//
//    }
    else {
        XJMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
        
        if (cell == nil) {
            cell = [[XJMyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
        }
        [cell setUpIndexPath:indexPath Imge:self.imgsArray[indexPath.row] Title:self.titlesArray[indexPath.row]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self gotoOrderWithIndex:4];
    }
//    else if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            [self gotoChuzu];
//        }
//        else {
//            if (XJUserAboutManageer.uModel.rent.status == 0 || XJUserAboutManageer.uModel.banStatus) {
//                //出租信息简介
//                ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
//                controller.urlString = @"http://7xwsly.com1.z0.glb.clouddn.com/wmgy/playHelp.html";
//                controller.isHideBar = YES;
//                controller.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//            else {
//                //用户数据统计
//                ZZUserStatisDataViewController *controller = [[ZZUserStatisDataViewController alloc] init];
//                controller.urlString = [NSString stringWithFormat:@"%@user/%@/stats/page",APIBASE,XJUserAboutManageer.uModel.uid];
//                controller.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//    }
    else {
        switch (indexPath.row) {
            case 0: {
                //我的钱包
                [self.navigationController pushViewController:[XJMyWalletVC new] animated:YES];
                break;
            }
            case 1: {
                //我的微信号
                self.selecttype = 0;

                if (XJUserAboutManageer.uModel.faces.count == 0) {
                    [self showAlerVCtitle:@"目前账户安全级别较低，将进行身份识别，否则无法设置微信号" message:@"" sureTitle:@"前往" cancelTitle:@"取消" sureBlcok:^{
                        //验证人脸
                        XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
                        [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
                        [self presentViewController:lvc animated:YES completion:nil];
                        lvc.endBlock = ^(UIImage * _Nonnull bestImg) {
                            [self checkIshack:bestImg];
                        };
                    } cancelBlock:^{
                        
                    }];
                    return;
                }
                
                [self.navigationController pushViewController:[XJMywechatVC new] animated:YES];
                break;
            }
            case 2: {
                //已查看微信号
                [self.navigationController pushViewController:[XJHasReviewWechatVC new] animated:YES];
                break;
            }
            case 3: {
                //实名认证
              
                self.selecttype = 1;
    //            if ([self isNeedToCheck:1]) {
    //                break;
    //            }
                if (XJUserAboutManageer.uModel.faces.count == 0) {
                    [self showAlerVCtitle:@"目前账户安全级别较低，将进行身份识别，否则无法设置微信号" message:@"" sureTitle:@"前往" cancelTitle:@"取消" sureBlcok:^{
                        //验证人脸
                        XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
                        [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
                        [self presentViewController:lvc animated:YES completion:nil];
                        lvc.endBlock = ^(UIImage * _Nonnull bestImg) {
                            [self checkIshack:bestImg];
                        };
                    } cancelBlock:^{
                        
                    }];
                    return;
                }
                
                [self.navigationController pushViewController:[XJRealNameAutoVC new] animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

// 申请达人(出租自己)
- (void)gotoChuzu {
    WEAK_SELF();
    BOOL canProceed = [XJUserAboutManageer canApplyTalentWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        if (!success) {
            if (infoIncompleteType == 0) {
                self.selecttype = 3;
                // 去验证人脸
                if (!isCancel) {
                    XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
                    [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
                    [self presentViewController:lvc animated:YES completion:nil];
                    lvc.endBlock = ^(UIImage * _Nonnull bestImg) {
                        [self checkIshack:bestImg];
                    };
                }
            }
            else if (infoIncompleteType == 1) {
                self.selecttype = 3;
                // 去上传真实头像
                if (!isCancel) {
                    XJUploadRealHeadImgVC *upVC = [XJUploadRealHeadImgVC new];
                    [self.navigationController pushViewController:upVC animated:YES];
                    upVC.endBlock = ^{
                        [self isNeedToCheck:self.selecttype];
                    };
                }
            }
        }
    }];
    
    if (!canProceed) {
        return;
    }
    
    if (XJUserAboutManageer.sysCofigModel.open_rent_need_pay_module) {   // 有开启出租收费
        if (XJUserAboutManageer.uModel.rent_need_pay) { //此人出租需要付费
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstProtocol]) { // 需要先去同意协议
                [self gotoRentalAgreementVC];
            }
            else {
                [self gotoUserChuZuVC];
            }
        }
        else {   //不需要付费（字段的值会根据用户是否是男性，大陆，是否已付费，老用户等条件）
            [self gotoUserChuZuVC];
        }
    }
    else {
        [self gotoUserChuZuVC];
    }
}

#pragma mark 是否需要验证
//0 设置微信号 1实名认证
- (BOOL)isNeedToCheck:(NSInteger)type{
    
    
    // 如果没有人脸
    NSString *facetitle = type == 0 ? @"目前账户安全级别较低，将进行身份识别，否则无法设置微信号":@"目前账户安全级别较低，将进行身份识别，否则无法实名认证";
    if (XJUserAboutManageer.uModel.faces.count == 0) {
        
        [self showAlerVCtitle:facetitle message:@"" sureTitle:@"前往" cancelTitle:@"取消" sureBlcok:^{
            //验证人脸
            
                XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
                [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
//                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
                [self presentViewController:lvc animated:YES completion:nil];
               lvc.endBlock = ^(UIImage * _Nonnull bestImg) {
                   
                   [self checkIshack:bestImg];
                   
                };
           
            
            
            
        } cancelBlock:^{
            
        }];
        return YES;
        
    }
    
    XJPhoto *photo = XJUserAboutManageer.uModel.photos_origin.firstObject;

    NSString *phototitle = type == 0 ?@"为确保资料真实有效，填写微信号需要您上传本人真实头像":@"您未上传本人正脸五官清晰照，不能实名认证，请前往上传真实头像";
    if (type == 0) {
        phototitle = @"为确保资料真实有效，填写微信号需要您上传本人真实头像";
    }
    else if (type == 1) {
        phototitle = @"您未上传本人正脸五官清晰照，不能实名认证，请前往上传真实头像";
    }
    else if (type == 3) {
        phototitle =  @"您未上传本人正脸五官清晰照，无法发布出租信息，请前往上传真实头像";
    }
    if (photo == nil || photo.face_detect_status != 3) {
        
        [self showAlerVCtitle:phototitle message:@"" sureTitle:@"前往" cancelTitle:@"取消" sureBlcok:^{
            //去上传真实头像
            
            XJUploadRealHeadImgVC *upVC = [XJUploadRealHeadImgVC new];
            [self.navigationController pushViewController:upVC animated:YES];
            upVC.endBlock = ^{
                [self isNeedToCheck:self.selecttype];
            };
            
            
        } cancelBlock:^{
            
        }];
        return YES;
    }
    return NO;
}

- (void)checkIshack:(UIImage *)bestimg{
    
    [MBManager showWaitingWithTitle:@"验证人脸中..."];
    [XJUploader uploadImage:bestimg progress:^(NSString *key, float percent) {
    } success:^(NSString * _Nonnull url) {
        
        [AskManager POST:API_PHOTOT_IS_HACK_POST dict:@{@"image_best":url}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                
                NSString *isHack = data[@"isHack"];
                if ([isHack isEqualToString:@"true"]) {
                    [self showAlerVCtitle:@"检测失败" message:@"请重新刷脸" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                        
                    } cancelBlock:^{
                        
                    }];
                }else{
                    [self pushFaces:url];
                }
            }else{
                
                [self showAlerVCtitle:@"检测失败" message:@"" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                    
                } cancelBlock:^{
                    
                }];
                
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
        [MBManager hideAlert];
    } failure:^{
        [MBManager hideAlert];
    }];
    
}

//更新face到服务器
- (void)pushFaces:(NSString *)url{
    
    NSArray *urlArr = @[url];
    [AskManager POST:API_UPDATA_JOBS dict:@{@"faces":urlArr}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
            XJUserAboutManageer.uModel = umodel;
            [MBManager showBriefAlert:@"检测成功"];

            [self isNeedToCheck:self.selecttype];
        }
    } failure:^(NSError *error) {
        [MBManager showBriefAlert:@"检测失败"];
    }];
}

// 出租协议
- (void)gotoRentalAgreementVC {
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 出租信息
 */
- (void)gotoUserChuZuVC {
    WEAK_SELF()
    //未出租状态前往申请达人，其余状态进入主题管理
    if (XJUserAboutManageer.uModel.rent.status == 0) {
        // 没有打开定位权限不给去添加技能
        if (![XJUtils isAllowLocation]) {
            return;
        }
        
        ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
        registerRent.type = RentTypeRegister;
        [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
            ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        [self.navigationController presentViewController:registerRent animated:YES completion:nil];
    }
    else {
        ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (!XJUserAboutManageer.userFirstRent) {
        XJUserAboutManageer.userFirstRent = @"userFirstRent";
        [self manageRedView];
    }
}

#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableHeaderView:self.headView];
        

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_tableView registerClass:[ZZUserCenterOrderCell class] forCellReuseIdentifier:@"ordercell"];
        [_tableView registerClass:[ZZUserCenterRentGuideCell class] forCellReuseIdentifier:@"ZZUserCenterRentGuideCell"];
        [_tableView registerClass:[ZZUserCenterRespondCell class] forCellReuseIdentifier:@"ZZUserCenterRespondCell"];
        [_tableView registerClass:[ZZUserCenterBaseCell class] forCellReuseIdentifier:@"ZZUserCenterBaseCell"];
        
    }
    return _tableView;
}

- (XJMyHeadView *)headView{
    if (!_headView) {
        
        _headView = [[XJMyHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        _headView.delegate = self;
        _headView.backgroundColor = UIColor.whiteColor;
    }
    
    return _headView;
    
}
- (NSArray *)imgsArray{
    
    if (!_imgsArray) {
        
        _imgsArray = @[@"mywalletimg",@"mywechatimg",@"myreviewimg",@"myattimg"];
    }
    return _imgsArray;
}
- (NSArray *)titlesArray{
    
    if (!_titlesArray) {
        
        _titlesArray = @[@"我的钱包",@"我的微信号",@"已查看微信号",@"实名认证"];
    }
    return _titlesArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [MBManager showLoading];
    [self manageRedView];
//    if (!_shouldRefresh) {
    [XJUserModel loadUser:XJUserAboutManageer.uModel.uid param:nil succeed:^(id data, XJRequestError *rError) {
            if (!rError && data) {
                XJUserModel *userModel = [XJUserModel yy_modelWithDictionary:data];
                XJUserAboutManageer.uModel = userModel;
                XJUserAboutManageer.isLogin = YES;
                [self.headView setUpHeadViewInfo:XJUserAboutManageer.uModel];
                [self manageRedView];
                if (self.tableView) {
                    [self.tableView reloadData];
                }
                
            }
            [MBManager hideAlert];
        } failure:^(NSError *error) {
            [MBManager hideAlert];
        }];
}
@end
