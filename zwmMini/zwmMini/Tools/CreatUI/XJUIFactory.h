//
//  XJUIFactory.h
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XJUIFactory : NSObject

//UIView
+(UIView *)creatUIViewWithFrame:(CGRect)frame
                      addToView:(UIView *)toview
                      backColor:(UIColor *)bgcolor;

//UILabel
+(UILabel *)creatUILabelWithFrame:(CGRect)frame
                        addToView:(UIView *)toview
                        textColor:(UIColor *)textcolor
                             text:(NSString *)text
                             font:(UIFont *)font
                     textInCenter:(BOOL)iscenter;

//UIButton
+(UIButton *)creatUIButtonWithFrame:(CGRect)frame
                          addToView:(UIView *)toview
                          backColor:(UIColor *)bgcolor
                         nomalTitle:(NSString *)title
                         titleColor:(UIColor *)titlecolor
                          titleFont:(UIFont *)font
                     nomalImageName:(NSString *)nimage
                    selectImageName:(NSString *)simage
                             target:(id)target
                             action:(SEL)action;

//UIImageView
+(UIImageView *)creatUIImageViewWithFrame:(CGRect)frame
                                addToView:(UIView *)toview
                                 imageUrl:(NSString *)url
                          placehoderImage:(NSString *)placeimage;

//UITableview
+(UITableView *)creatUITableViewWithFrame:(CGRect)frame
                                addToView:(UIView *)toview
                                 delegate:(id)delegate
                               iscellLine:(BOOL)line
                                  isGroup:(BOOL)group;




//UITextFiled
+(UITextField *)creatUITextFiledWithFrame:(CGRect)frame
                                addToView:(UIView *)toview
                                textColor:(UIColor *)color
                                 textFont:(UIFont *)font
                          placeholderText:(NSString *)placetext
                     placeholderTectColor:(UIColor *)pcolor
                          placeholderFont:(UIFont *)pfont
                                 delegate:(id)delegate;

//UIScrollView
+(UIScrollView *)creatUIScrollViewWithFram:(CGRect)fram
                                 addToView:(UIView *)toview
                                 backColor:(UIColor *)color
                               contentSize:(CGSize)size
                                  delegate:(id)delegate
                                    isPage:(BOOL)ispage;
//按钮背景layer
+ (CAGradientLayer *)creatGradientLayer:(CGRect)frame;
@end

