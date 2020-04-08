//
//  XJBaseWebVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/13.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>


@interface XJBaseWebVC : UIViewController

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, assign) BOOL hideAllBtn; ///< 隐藏导航栏上除返回图标的所有按钮

- (void)resetWebViewFrame:(CGRect)frame;
- (void)webViewloadRequestWithURLString:(NSString *)URLSting;
- (void)backViewCtrl;
- (void)deleteWebCache;
@end


