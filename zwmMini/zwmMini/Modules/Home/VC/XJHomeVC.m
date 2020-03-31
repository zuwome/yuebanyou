//
//  XJHomeVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJHomeVC.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "ZZCityViewController.h"
#import "XJNaviVC.h"
#import "XJSeachUserVC.h"
#import "XJHomeTitleSelectView.h"
#import "XJRecommondVC.h"
#import "XJNearVC.h"
#import "XJLookoverOtherUserVC.h"
#import "XJNaviVC.h"
#import "XJLoginVC.h"
#import "XJPernalDataVC.h"

#import "XJMessageLoginVC.h"
//#import "MGFaceIDNetWork.h"
//#import <MGFaceIDLiveDetect/MGFaceIDLiveDetect.h>

@interface XJHomeVC ()<XJHomeTitleViewDlegate,UIScrollViewDelegate>
//@property (strong, nonatomic) UISegmentedControl *isMeglive;

@property(nonatomic,strong) UIButton *leftButton;
@property (nonatomic, strong) AMapLocationManager *mapLocationManager;
@property(nonatomic,copy) NSString *selectCity;
@property(nonatomic,strong) XJHomeTitleSelectView *titilView;
@property(nonatomic,strong) UIScrollView *backScrollView;
@property(nonatomic,strong) XJRecommondVC *recommondVC;
@property(nonatomic,strong) XJNearVC *nearVC;




@end

@implementation XJHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self getLocationAddress];
//    });

    [self creatUI];
    //未登录跳到登录页
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushToLogin)
                                                 name:clickMyisLogin
                                               object:nil];
    //后台进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isloginsuccessAction) name:loginISSuccess
                                               object:nil];
    
    // 注册成功
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(registrationSuccessAction) name:RegistrationSuccessNotification
//                                               object:nil];

    
}

- (void)applicationBecomeActive{
    if (self.tabBarController.selectedIndex == 0 ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getLocationAddress];
        });
    }
}

- (void)pushToLogin{
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController pushViewController:[XJLoginVC new] animated:YES];
    }
}

- (void)isloginsuccessAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getLocationAddress];
    });
}

- (void)registrationSuccessAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getLocationAddress];
    });
}

- (void)creatUI{
    
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftitem;
    
    [self showNavRightButton:@"" action:@selector(rigthAction) image:GetImage(@"fangdajing") imageOn:GetImage(@"fangdajing")];
    self.navigationItem.titleView = self.titilView;
    [self addChildViewController:self.recommondVC];
    UIView *recommondView = self.recommondVC.view;
    [self.backScrollView addSubview:recommondView];
    recommondView.frame = CGRectMake(0, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight-iPhoneTabbarHeight);
    @WeakObj(self);
    self.recommondVC.block = ^(XJHomeListModel * _Nonnull homelistModel) {
        @StrongObj(self);

        if ([XJUserAboutManageer.uModel.uid isEqualToString:homelistModel.user.uid]) {
            [self.navigationController pushViewController:[XJPernalDataVC new] animated:YES];
        }else{
            XJLookoverOtherUserVC *lookvc = [XJLookoverOtherUserVC new];
            lookvc.topUserModel = homelistModel.user;
            [self.navigationController pushViewController:lookvc animated:YES];
            
        }
                
    };
    [self addChildViewController:self.nearVC];
    UIView *nearView = self.nearVC.view;
    [self.backScrollView addSubview:nearView];
    nearView.frame = CGRectMake(kScreenWidth, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight-iPhoneTabbarHeight);

    self.nearVC.block = ^(XJHomeListModel * _Nonnull homelistModel) {
        @StrongObj(self);
        //是自己就跳到个人详情
        if ([XJUserAboutManageer.uModel.uid isEqualToString:homelistModel.user.uid]) {
            [self.navigationController pushViewController:[XJPernalDataVC new] animated:YES];
        }else{
            XJLookoverOtherUserVC *lookvc = [XJLookoverOtherUserVC new];
            lookvc.topUserModel = homelistModel.user;
            [self.navigationController pushViewController:lookvc animated:YES];
        }
       
        
    };

}



- (void)getLocationAddress {
    if (!NULLString(XJUserAboutManageer.cityName)) {
        self.selectCity = XJUserAboutManageer.cityName;
    }
    
    
//    if (NULLString(XJUserAboutManageer.isFirstOpenApp)) {
//    
//        [MBManager showWaitingWithTitle:@"正在获取当前位置..."];
    
        XJUserAboutManageer.isFirstOpenApp = @"isnofirstopen";

//    }

    
    [self.mapLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (!error) {
//            NSLog(@"regeocode = %@",regeocode);
//            NSLog(@"location = %lf====%lf",location.coordinate.longitude,location.coordinate.latitude);
            [MBManager hideAlert];

            //经纬度
            NSString *lng = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
            NSString *lat = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
            if (NULLString(lng)) {
                return ;
            }
            if (NULLString(regeocode.country) || NULLString(regeocode.province) || NULLString(regeocode.district) || NULLString(regeocode.city)) {
                return;
            }
            [self.leftButton setTitle:regeocode.city forState:UIControlStateNormal];
            
            XJUserAboutManageer.provinceCity = @{@"country":regeocode.country,@"province":regeocode.province,@"city":regeocode.city,@"district":regeocode.district};
            XJUserAboutManageer.cityName = regeocode.city;
            
            if (!NULLString(XJUserAboutManageer.localLatitude)) {
                
                if (![lat isEqualToString:XJUserAboutManageer.localLatitude] || ![lng isEqualToString:XJUserAboutManageer.localLatitude] ) {
                    
                    XJUserAboutManageer.localLongitude = lng;
                    XJUserAboutManageer.localLatitude = lat;
                    
                    if (XJUserAboutManageer.isLogin) {
                        //更新用户信息经纬度
                        [self updateUserLocation:lat andLng:lng];
                    }else{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:refreshNearTableViewName object:self];

                    }
                    
                }
            }else{
                
                XJUserAboutManageer.localLongitude = lng;
                XJUserAboutManageer.localLatitude = lat;
                if (XJUserAboutManageer.isLogin) {
                    //更新用户信息经纬度
                    [self updateUserLocation:lat andLng:lng];
                }else{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:refreshNearTableViewName object:self];

                }
              
                
            }
           
            self.selectCity = regeocode.city;
           

        }else{
            
            NSLog(@"%@",error);
            [MBManager hideAlert];

        }
        
    }];
    
}
//
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (XJUserAboutManageer.isLogin) {
        
       //更新用户信息经纬度
        if (!NULLString(XJUserAboutManageer.localLatitude)) {
            [self updateUserLocation:XJUserAboutManageer.localLatitude andLng:XJUserAboutManageer.localLongitude];
        }
        
        
    }
    
}

- (void)updateUserLocation:(NSString *)lat andLng:(NSString *)lng{
    
    [AskManager POST:API_UPDATA_JOBS dict:@{@"lat":lat,@"lng":lng}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:refreshNearTableViewName object:self];

            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)leftBtnAction{
    
    NSLog(@"选择城市");
    ZZCityViewController *controller = [[ZZCityViewController alloc] init];
    controller.selectCity = ^(NSString *cityName) {
        [self.leftButton setTitle:cityName forState:UIControlStateNormal];
        self.selectCity = cityName;
        XJUserAboutManageer.cityName = cityName;
        
        [self.recommondVC refresh];
        [self.nearVC refresh];
    };
    XJNaviVC  *nav = [[XJNaviVC alloc] initWithRootViewController:controller] ;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
//筛选
- (void)rigthAction{
    
    [self.navigationController pushViewController:[XJSeachUserVC new] animated:YES];
    
}


#pragma mark titleViewDlegate

- (void)clickRecommond{
    
    [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)clickNear{
    [self.backScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];

    
}




#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.backScrollView]) {
        
        CGPoint offset=scrollView.contentOffset;
        CGFloat page = offset.x/kScreenWidth;
        [self.titilView setBtnIndex:page];
        
    }
   
    
}




#pragma mark lazy

- (AMapLocationManager *)mapLocationManager{
    
    if (!_mapLocationManager) {
        _mapLocationManager = [[AMapLocationManager alloc] init];
//        _mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest;

    }
    return _mapLocationManager;
}


- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 60, 44);
        if (!NULLString(XJUserAboutManageer.cityName)) {
            [_leftButton setTitle:XJUserAboutManageer.cityName forState:UIControlStateNormal];
        }else{
            [_leftButton setTitle:@"全国 " forState:UIControlStateNormal];
        }
        _leftButton.titleLabel.font = defaultFont(14);
        [_leftButton setTitleColor:defaultBlack forState:UIControlStateNormal];
        [_leftButton setImage:[[UIImage imageNamed:@"triangle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_leftButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (XJHomeTitleSelectView *)titilView{
    
    if (!_titilView) {
        _titilView = [[XJHomeTitleSelectView alloc] initWithFrame:CGRectMake(0, 0, 150, 26)];
        _titilView.delegate = self;
    }
    return _titilView;
    
    
}

- (UIScrollView *)backScrollView{
    
    if (!_backScrollView) {
        _backScrollView = [XJUIFactory creatUIScrollViewWithFram:CGRectMake(0, 0,kScreenWidth , kScreenHeight - SafeAreaBottomHeight-SafeAreaTopHeight-iPhoneTabbarHeight) addToView:self.view backColor:defaultWhite contentSize:CGSizeMake(kScreenWidth*2,0) delegate:self isPage:YES];
    }
    
    return _backScrollView;
    
    
}

- (XJRecommondVC *)recommondVC{
    if (!_recommondVC) {
        
        _recommondVC = [[XJRecommondVC alloc] init];
        
    }
    return _recommondVC;
    
}

- (XJNearVC *)nearVC{
    if (!_nearVC) {
        
        _nearVC = [[XJNearVC alloc] init];
        
    }
    return _nearVC;
    
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
