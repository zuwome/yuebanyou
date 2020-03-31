//
//  UITabBar+Badge.m
//  zuwome
//
//  Created by angBiu on 16/6/1.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarItemNums 3.0    //tabbar的数量

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *subView in self.subviews) {
            if (subView.tag == 888+index) {
                [subView removeFromSuperview];
            }
        }
    });
    
}

@end
