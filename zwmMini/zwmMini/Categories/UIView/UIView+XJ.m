//
//  UIView+XJ.m
//  BaseVCDemo
//
//  Created by Batata on 2018/10/15.
//  Copyright © 2018 BaseCV. All rights reserved.
//

#import "UIView+XJ.h"

@implementation UIView (XJ)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame= frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)alignHorizontal
{
    self.x = (self.superview.width - self.width) * 0.5;
}

- (void)alignVertical
{
    self.y = (self.superview.height - self.height) *0.5;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    
    if (borderWidth < 0) {
        return;
    }
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (BOOL)isShowOnWindow
{
    //主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //相对于父控件转换之后的rect
    CGRect newRect = [keyWindow convertRect:self.frame fromView:self.superview];
    //主窗口的bounds
    CGRect winBounds = keyWindow.bounds;
    //判断两个坐标系是否有交汇的地方，返回bool值
    BOOL isIntersects =  CGRectIntersectsRect(newRect, winBounds);
    if (self.hidden != YES && self.alpha >0.01 && self.window == keyWindow && isIntersects) {
        return YES;
    }else{
        return NO;
    }
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
- (CGFloat)borderWidth
{
    return self.borderWidth;
}

- (UIColor *)borderColor
{
    return self.borderColor;
    
}

- (CGFloat)cornerRadius
{
    return self.cornerRadius;
}

- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (UIView *)cornerRadiusViewWithAllRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:YES andTopRight:YES andBottomLeft:YES andBottomRight:YES];
}

- (UIView *)cornerRadiusViewWithTopRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:YES andTopRight:YES andBottomLeft:NO andBottomRight:NO];
}

- (UIView *)cornerRadiusViewWithBottomRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:NO andTopRight:NO andBottomLeft:YES andBottomRight:YES];
}

- (UIView *)cornerRadiusViewWithLeftRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:YES andTopRight:NO andBottomLeft:YES andBottomRight:NO];
}

- (UIView *)cornerRadiusViewWithRightRadius:(CGFloat)radius {
    return [self cornerRadiusViewWithRadius:radius andTopLeft:NO andTopRight:YES andBottomLeft:NO andBottomRight:YES];
}

- (UIView *)cornerRadiusViewWithRadius:(CGFloat)radius
                            andTopLeft:(BOOL)topLeft
                           andTopRight:(BOOL)topRight
                         andBottomLeft:(BOOL)bottomLeft
                        andBottomRight:(BOOL)bottomRight {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:
                              (
                               (topLeft == YES ? UIRectCornerTopLeft : 0) |
                               (topRight == YES ? UIRectCornerTopRight : 0) |
                               (bottomLeft == YES ? UIRectCornerBottomLeft : 0) |
                               (bottomRight == YES ? UIRectCornerBottomRight : 0)
                               )
                                                         cornerRadii:CGSizeMake(radius, radius)];
    // 创建遮罩层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;   // 轨迹
    self.layer.mask = maskLayer;
    
    return self;
}


@end
