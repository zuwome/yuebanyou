//
//  XJTabBarVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJTabBarVC.h"
#import "XJTabBar.h"
#import "XJNaviVC.h"
#import "XJMyVC.h"
#import "XJLoginVC.h"
#import "XJMessageVC.h"
#import "ZZUpdateAlertView.h"

@interface XJTabBarVC ()<UITabBarControllerDelegate>


@end


@implementation XJTabBarVC




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self resetTabBar];
    [self setupVCs];
    [self getSystemConfig];
}

//获取系统配置信息
- (void)getSystemConfig{
    
    [AskManager GET:API_GET_SYSTEM_CONFIG dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJSystemCofigModel *sysmodel = [XJSystemCofigModel yy_modelWithDictionary:data];
            XJUserAboutManageer.sysCofigModel = sysmodel;
            [self fetchPriceConfig:NO inViewController:self block:nil];
            // 查看是否有新的版本
            if (sysmodel.version.haveNewVersion && sysmodel.version.version.des.length != 0) {
                ZZUpdateAlertView *alertView = [[ZZUpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                [self.view.window addSubview:alertView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  获取价格配置信息(视频、聊天价格)
 */
- (void)fetchPriceConfig:(BOOL)needRetry
        inViewController:(UIViewController *)viewController
                   block:(void (^)(BOOL))block {
    [AskManager GET:[NSString stringWithFormat:@"room/%@/user_config",XJUserAboutManageer.uModel.uid] dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            XJPriceConfigModel *priceModel = [XJPriceConfigModel yy_modelWithDictionary:data];
            XJUserAboutManageer.priceConfig = priceModel;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    XJNaviVC *navCtrl = (XJNaviVC *)viewController;
    UIViewController *rootCtrl = navCtrl.topViewController;
    
    if([rootCtrl isKindOfClass:[XJMyVC class]] || [rootCtrl isKindOfClass:[XJMessageVC class]]) {
        
        if (XJUserAboutManageer.isLogin) {
            return YES;
        
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:clickMyisLogin object:self];
            return NO;
            
        }
       
    }
    
    return YES;
    
  
    
}




// 自定义TabBar
- (void)resetTabBar {
    //创建自定义TabBar 利用KVC替换默认的TabBar
    XJTabBar *myTabBar = [XJTabBar new ];
//    myTabBar.tabBarDelegate = self;
    [self setValue:myTabBar forKey:@"tabBar"];
    
}

/** 配置底部标签栏 */
- (void)setupVCs {
    NSArray *ctrlArr = @[@"XJHomeVC",
                         @"XJMessageVC",
                         @"XJMyVC"];
    NSArray *imgOffAry = @[@"snoshouye",
                           @"snoxiaoxi",
                           @"snowode"];
    NSArray *imgOnAry = @[@"sshouye",
                          @"sxiaoxi",
                          @"swode"];
    NSArray *titleAry =  @[@"首页",
                           @"消息",
                           @"我的"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSUInteger i = 0; i < ctrlArr.count; i++)
    {
        Class cls = NSClassFromString(ctrlArr[i]);
        UIViewController *vCtrl = (UIViewController *)[[cls alloc] init];
        vCtrl.tabBarItem.tag = i;
        vCtrl.tabBarItem.title = titleAry[i];
        // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
        NSDictionary *dict = [NSDictionary dictionaryWithObject:defaultBlack forKey:NSForegroundColorAttributeName];
        [vCtrl.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
        vCtrl.tabBarItem.image = [[UIImage imageNamed:imgOffAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vCtrl.tabBarItem.selectedImage = [[UIImage imageNamed:imgOnAry[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        XJNaviVC *navi = [[XJNaviVC alloc] initWithRootViewController:vCtrl];
        [array addObject:navi];
        
    }
    self.viewControllers = array;
}

@end
