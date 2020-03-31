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

static NSString *myTableviewIdentifier = @"mytableviewIdentifier";

@interface XJMyVC ()<UITableViewDelegate,UITableViewDataSource,XJMyHeadViewDelegate, XJEditMyInfoVCDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) XJMyHeadView *headView;
@property(nonatomic,copy) NSArray *titlesArray;
@property(nonatomic,copy) NSArray *imgsArray;
@property(nonatomic,assign) NSInteger selecttype;//0 设置微信号 1实名认证

@property(nonatomic,assign) BOOL shouldRefresh;

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
//        [MBManager showBriefAlert:@"您已被封禁"];
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
    return 65.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imgsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
    
    if (cell == nil) {
        cell = [[XJMyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
    }
    [cell setUpIndexPath:indexPath Imge:self.imgsArray[indexPath.row] Title:self.titlesArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
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
        
    }
    return _tableView;
}

- (XJMyHeadView *)headView{
    if (!_headView) {
        
        _headView = [[XJMyHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        _headView.delegate = self;
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
    
//    if (!_shouldRefresh) {
        [AskManager GET:API_GET_USERINFO_LIST dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
             if (!rError) {
                XJUserAboutManageer.uModel = [XJUserModel yy_modelWithDictionary:data];
                [self.headView setUpHeadViewInfo:XJUserAboutManageer.uModel];
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
