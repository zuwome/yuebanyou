//
//  XJChatLbel.m
//  zwmMini
//
//  Created by Batata on 2018/12/15.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJChatLbel.h"

@interface XJChatLbel()

@property (assign, nonatomic) UIEdgeInsets edgeInsets;


@end

@implementation XJChatLbel

//下面三个方法用来初始化edgeInsets
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return self;
}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        self.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
//    }
//    return self;
//}
//
//
//// 修改绘制文字的区域，edgeInsets增加bounds
//-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
//{
//    
//    /*
//     调用父类该方法
//     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
//     */
//    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
//                                                                 self.edgeInsets) limitedToNumberOfLines:numberOfLines];
//    //根据edgeInsets，修改绘制文字的bounds
//    rect.origin.x -= self.edgeInsets.left;
//    rect.origin.y -= self.edgeInsets.top;
//    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
//    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
//    return rect;
//}
//
//
//- (void)drawRect:(CGRect)rect {
//
//
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
//}


@end
