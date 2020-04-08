//
//  XJTabBar.m
//  BaseVCDemo
//
//  Created by Batata on 2018/10/15.
//  Copyright © 2018 BaseCV. All rights reserved.
//

#import "XJTabBar.h"

 #define AddButtonMargin 10

@interface XJTabBar()

//指向中间“+”按钮
@property (nonatomic,weak) UIButton *addButton;

@end

@implementation XJTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
//        self.backgroundColor = [UIColor clearColor];
//        [self setShadowImage:[UIImage new]];
//
//        UIButton *addBtn = [[UIButton alloc] init];
//        [addBtn setBackgroundImage:[UIImage imageNamed:@"newadd"] forState:UIControlStateNormal];
//        [addBtn setBackgroundImage:[UIImage imageNamed:@"newadd"] forState:UIControlStateHighlighted];
//        [addBtn addTarget:self action:@selector(addBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:addBtn];
//        self.addButton = addBtn;
////
//        if (iPhoneX) {
//            if (kScreenWidth == 414.f) {
//                [self setBackgroundImage:[UIImage imageNamed:@"tbbarbg_max"]];
//            } else {
//                [self setBackgroundImage:[UIImage imageNamed:@"tbbarbg_iphoneX"]];
//            }
//        } else {
//            if (kScreenWidth == 414.f) {
//                [self setBackgroundImage:[UIImage imageNamed:@"tbbarbg_plus"]];
//            } else if (kScreenWidth == 320.f) {
//                [self setBackgroundImage:[UIImage imageNamed:@"tbbarbg_5"]];
//            } else {
//                [self setBackgroundImage:[UIImage imageNamed:@"tbbarbg_6s"]];
//            }
//        }
    }
    return self;
}

// 响应中间“+”按钮点击事件
//- (void)addBtnDidClick {
//    if([self.tabBarDelegate respondsToSelector:@selector(addButtonClick:)]) {
//        [self.tabBarDelegate addButtonClick:self];
//    }
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    //去掉TabBar上部的横线
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
//            UIImageView *linev = obj.subviews[1];
//            linev.hidden = YES;
//        }
//    }];
//
//    [self bringSubviewToFront:self.addButton];
//
//    //设置“+”按钮的大小为图片的大小
//    self.addButton.size = CGSizeMake(self.addButton.currentBackgroundImage.size.width, self.addButton.currentBackgroundImage.size.height);
//    //设置“+”按钮的位置
//    self.addButton.centerX = self.centerX;
//    self.addButton.centerY = self.height * 0.5 - (iPhoneX? 3.2 *AddButtonMargin: 1.68 * AddButtonMargin);
//    if (kScreenWidth == 414.f && iPhoneX) {
//        self.addButton.centerY = self.height * 0.5 - (2.4 * AddButtonMargin);
//    }
//}

//// 重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.isHidden == NO) {
//        //将当前TabBar的触摸点转换坐标系，转换到“+”按钮的身上，生成一个新的点
//        CGPoint newA = [self convertPoint:point toView:self.addButton];
//        //判断如果这个新的点是在“+”按钮身上，那么处理点击事件最合适的view就是“+”按钮
//        if ( [self.addButton pointInside:newA withEvent:event]) {
//            return self.addButton;
//        } else {
//            //如果点不在“+”按钮身上，直接让系统处理就可以了
//            return [super hitTest:point withEvent:event];
//        }
//    } else {
//        //TabBar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
//        return [super hitTest:point withEvent:event];
//    }
//}

@end
