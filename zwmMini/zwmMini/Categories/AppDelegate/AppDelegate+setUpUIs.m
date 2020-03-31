//
//  AppDelegate+setUpUIs.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "AppDelegate+setUpUIs.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@implementation AppDelegate (setUpUIs)



#pragma mark - 全局外观
- (void)setupApperance {
    // 智能键盘的工具条关闭
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    
    // 状态栏黑色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    // 导航栏
//    [UINavigationBar appearance].translucent = NO;
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    //tabbar
    [[UITabBar appearance] setTranslucent:NO];
    
    // 按钮
    [[UIButton appearance] setExclusiveTouch:YES];  // 禁止按钮同时触发
    [[UIButton appearance] setShowsTouchWhenHighlighted:NO];   // 按钮被点击高亮提醒
    
    
    // iOS 11 ScrollView 偏移量
//    if (@available(iOS 11.0, *)){
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }
    
    // TableView
    // 关闭Cell高度估算
//    [UITableView appearance].estimatedRowHeight = 0;
//    [UITableView appearance].estimatedSectionHeaderHeight = 0;
//    [UITableView appearance].estimatedSectionFooterHeight = 0;
    // 关系cell点击效果
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
}

@end
