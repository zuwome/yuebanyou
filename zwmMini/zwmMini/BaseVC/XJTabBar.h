//
//  XJTabBar.h
//  BaseVCDemo
//
//  Created by Batata on 2018/10/15.
//  Copyright © 2018 BaseCV. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XJTabBar;

//XJTabBar的代理必须实现addButtonClick，以响应中间“+”按钮的点击事件
//@protocol XJTabBarDelegate <NSObject>
//
//- (void)addButtonClick:(XJTabBar *)tabBar;
//
//@end

@interface XJTabBar : UITabBar

//@property (nonatomic, weak) id <XJTabBarDelegate> tabBarDelegate;

@end


