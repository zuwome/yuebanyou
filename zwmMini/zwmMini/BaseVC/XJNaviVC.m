//
//  XJNaviVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJNaviVC.h"
#import "ZZCityViewController.h"
@interface XJNaviVC ()<UINavigationControllerDelegate>

@property (nonatomic, assign, getter=isAppearingVC) BOOL appearingVC; ///< 是否正在出现

@end

@implementation XJNaviVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setShadowImage:[UIImage new]];
    // 侧滑手势的代理对象是自己
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)popSelfVC {
    
    [self popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (UIBarButtonItem *)backButtonItem {
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 28, 28)];
    [bt setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [bt setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [bt addTarget:self action:@selector(popSelfVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bt];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = -5;
    
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    
//    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(popSelfVC)];
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// push时候因此TabBar，并且保证只push一个页面
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if (animated && self.isAppearingVC) {
        // 避免同一时间push多个界面导致的crash
        return ;
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 1) {
        viewController.navigationItem.leftBarButtonItem = [self backButtonItem];
    }
    if ([NSStringFromClass(viewController.class) isEqualToString:NSStringFromClass(ZZCityViewController.class)]) {
        
        viewController.navigationItem.leftBarButtonItem = [self backButtonItem];

    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.appearingVC = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.appearingVC = NO;
}

@end
