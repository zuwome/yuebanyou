//
//  UIView+XJ.h
//  BaseVCDemo
//
//  Created by Batata on 2018/10/15.
//  Copyright © 2018 BaseCV. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UIView (Category)
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

/////FRAME SHORTCUTS//////////////////////
/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/**
 *  判断是否显示在主窗口上面
 *
 *  @return 是否
 */
- (BOOL)isShowOnWindow;

- (UIViewController *)parentController;
- (void)removeAllSubviews;
//圆角
- (UIView *)cornerRadiusViewWithAllRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithTopRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithBottomRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithLeftRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithRightRadius:(CGFloat)radius;
- (UIView *)cornerRadiusViewWithRadius:(CGFloat)radius
                            andTopLeft:(BOOL)topLeft
                           andTopRight:(BOOL)topRight
                         andBottomLeft:(BOOL)bottomLeft
                        andBottomRight:(BOOL)bottomRight;
@end
