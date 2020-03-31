//
//  XJUIFactory.m
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJUIFactory.h"

@implementation XJUIFactory

+(UIView *)creatUIViewWithFrame:(CGRect)frame
                      addToView:(UIView *)toview
                      backColor:(UIColor *)bgcolor
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [toview addSubview:view];
    view.backgroundColor = bgcolor;
    return  view;
}


+(UILabel *)creatUILabelWithFrame:(CGRect)frame
                        addToView:(UIView *)toview
                        textColor:(UIColor *)textcolor
                             text:(NSString *)text
                             font:(UIFont *)font
                     textInCenter:(BOOL)iscenter;
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (toview) {
        [toview addSubview:label];

    }
    label.text = text;
    label.font = font;
    label.textColor = textcolor;
    label.textAlignment = iscenter ? NSTextAlignmentCenter: NSTextAlignmentLeft;
    return label;
}


+(UIButton *)creatUIButtonWithFrame:(CGRect)frame
                          addToView:(UIView *)toview
                          backColor:(UIColor *)bgcolor
                         nomalTitle:(NSString *)title
                         titleColor:(UIColor *)titlecolor
                          titleFont:(UIFont *)font
                     nomalImageName:(NSString *)nimage
                    selectImageName:(NSString *)simage
                             target:(id)target
                             action:(SEL)action
{
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    if (toview) {
        [toview addSubview:button];
    }
    button.backgroundColor = bgcolor;
    if (!NULLString(title)) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titlecolor forState:UIControlStateNormal];
        button.titleLabel.font = font;
    }
    if (!NULLString(nimage)) {
        [button setImage:[UIImage imageNamed:nimage] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:simage] forState:UIControlStateSelected];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    return button;
}

+(UIImageView *)creatUIImageViewWithFrame:(CGRect)frame
                                addToView:(UIView *)toview
                                 imageUrl:(NSString *)url
                          placehoderImage:(NSString *)placeimage{
    
    UIImageView *IV = [[UIImageView alloc] initWithFrame:frame];
    if (toview) {
        [toview addSubview:IV];

    }
    if (NULLString(url)) {
        IV.image = GetImage(placeimage);
    }else{
        [IV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:GetImage(placeimage)];
    }
    
    return IV;
    
}

+(UITableView *)creatUITableViewWithFrame:(CGRect)frame
                                addToView:(UIView *)toview
                                 delegate:(id)delegate
                               iscellLine:(BOOL)line
                                  isGroup:(BOOL)group;
{
    
    UITableView *tableview;
    if (group) {
        tableview = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    }else{
        tableview = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    }
    
    tableview.delegate = delegate;
    tableview.dataSource = delegate;
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.estimatedRowHeight = 0;
    tableview.estimatedSectionFooterHeight = 0;
    tableview.estimatedSectionHeaderHeight = 0;
    if (line) {
        tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [toview addSubview:tableview];
    return tableview;
}

+(UITextField *)creatUITextFiledWithFrame:(CGRect)frame
                                addToView:(UIView *)toview
                                textColor:(UIColor *)color
                                 textFont:(UIFont *)font
                          placeholderText:(NSString *)placetext
                     placeholderTectColor:(UIColor *)pcolor
                          placeholderFont:(UIFont *)pfont
                                 delegate:(id)delegate{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [toview addSubview:textField];
    //    [textField isFirstResponder];
    textField.placeholder = placetext;
    textField.font = font;
    textField.textColor = color;
    textField.delegate = delegate;
    [textField setValue:pcolor forKeyPath:@"placeholderLabel.textColor"];
    textField.borderStyle = UITextBorderStyleNone;
    return textField;
    
}

+(UIScrollView *)creatUIScrollViewWithFram:(CGRect)fram
                                 addToView:(UIView *)toview
                                 backColor:(UIColor *)color
                               contentSize:(CGSize)size
                                  delegate:(id)delegate
                                    isPage:(BOOL)ispage{
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:fram];
    [toview addSubview:scrollview];
    scrollview.backgroundColor = color;
    scrollview.contentSize = size;
    scrollview.delegate = delegate;
    scrollview.pagingEnabled = ispage;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;

    return scrollview;
}


+ (CAGradientLayer *)creatGradientLayer:(CGRect)frame{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGB(249, 40, 124).CGColor,(__bridge id)RGB(253, 115, 82).CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = frame;
    return gradientLayer;
    
}


@end
