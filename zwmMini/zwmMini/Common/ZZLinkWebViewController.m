 //
//  ZZLinkWebViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZLinkWebViewController.h"
//#import "ZZRentViewController.h"
//#import "ZZRecordViewController.h"

#import "ZZViewHelper.h"
//#import "ZZRightShareView.h"
#import "ZZLinkWebNavigationView.h"
//#import "ZZTopicDetailViewController.h"
//#import "ZZTabBarViewController.h"
//#import "ZZChatServerViewController.h"
//#import "ZZIntegralNaVView.h"
#import "WXApi.h"
//#import "ZZUserEditViewController.h"
//#import "ZZIDPhotoManagerViewController.h"
//#import "ZZPrivateChatPayManager.h"
//#import "kongxia-Swift.h"

@interface ZZLinkWebViewController () <UIWebViewDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *navigationLeftBtn;
;

@property (nonatomic, strong) ZZLinkWebNavigationView *navigationView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
//@property (nonatomic, strong) ZZRightShareView *shareView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, assign) BOOL pushHideBar;
@property (nonatomic, assign) BOOL isUploadToken;
@property (nonatomic, assign) BOOL isShowedSayHiFinishedView;
/**

 是否是自定义的黑色导航是的话就要改变状态栏
 */
@property (nonatomic,assign) BOOL isCustomBlackNav;
@end

@implementation ZZLinkWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isPush) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else if (!_isHideBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    if (_isPushNOHideNav) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (self.isCustomBlackNav) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 不懂为什么要 = NO
    if (!_isFromPay) {
        _isPush = NO;
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isPush && !_pushHideBar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if (self.isCustomBlackNav) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _pushHideBar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (XJUserAboutManageer.isLogin) {
        NSRange range1 = [_urlString rangeOfString:[NSString stringWithFormat:@"%@",[APIBASE stringByReplacingOccurrencesOfString:@"https://" withString:@""]]];
        NSRange range2 = [_urlString rangeOfString:@"access_token="];
        if (range1.location != NSNotFound && range2.location == NSNotFound) {
            _urlString = [NSString stringWithFormat:@"%@?access_token=%@",_urlString,XJUserAboutManageer.access_token];
        }
    }
    
    [self createViews];
    if (_isHideBar) {
        [self.view addSubview:self.navigationView];
        if (!_showShare) {
            self.navigationView.rightBtn.hidden = YES;
        }
    }
    else {
        [self createNavLeftButton];
        if (_showShare) {
            [self createRightBtn];
        }
    }
    if (_isPush&&_isShowLeftButton) {
        [self showNavLeftButton];
    }

}

- (void)createNavigationRightDoneBtn
{
    self.navigationRightDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationRightDoneBtn.frame = CGRectMake(0, 0, 70, 21);
    [self.navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:self.navigationRightDoneBtn];
    btnItem.width = kLeftEdgeInset;
    self.navigationItem.rightBarButtonItems = @[btnItem, rightBarButon];
    
}

/**
 设置黑色的背景

 @param titleNav 当前的导航的名称
 @param isUploadToken  是否上传token
 */
- (void)setCustomNavTitle:(NSString *)titleNav  isUploadToken:(BOOL)isUploadToken {
    _isCustomBlackNav = YES;
    _isUploadToken = YES;
//    ZZIntegralNaVView *view = [[ZZIntegralNaVView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVIGATIONBAR_HEIGHT) titleNavLabTitile:titleNav rightTitle:nil];
//    [self.view addSubview:view];
//      __weak typeof(self) Weakself = self;
//    view.leftNavClickBlock = ^{
//        [Weakself.navigationController popViewControllerAnimated:YES];
//    };
    
}

- (void)createNavLeftButton {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}


- (void)showNavLeftButton {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20,NAVIGATIONBAR_HEIGHT/2.0f-10, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createLeftBtn {
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [self.navigationLeftBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    [self.navigationLeftBtn addTarget:self action:@selector(leftDismissView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftBtnClick {
    if (IOS8_OR_LATER) {
        if (_wkWebView.canGoBack) {
            if (_isShowedSayHiFinishedView) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [_wkWebView goBack];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        if (_webView.canGoBack) {
            if (_isShowedSayHiFinishedView) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [_webView goBack];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)leftDismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createRightBtn {
    [self createNavigationRightDoneBtn];
    [self.navigationRightDoneBtn setImage:[UIImage imageNamed:@"icon_link_share_p"] forState:UIControlStateNormal];
    [self.navigationRightDoneBtn setImage:[UIImage imageNamed:@"icon_link_share_p"] forState:UIControlStateHighlighted];
    [self.navigationRightDoneBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightBtnClick {
    __weak typeof(self) Weakself = self;
//    if (!_shareView) {
//        _shareView = [[ZZRightShareView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:Weakself];
//        _shareView.shareUrl = _urlString;
//        _shareView.shareTitle = _shareTitle;
//        _shareView.shareContent = _shareContent;
//        _shareView.userImgUrl = _imgUrl;
//        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imgUrl];
//        _shareView.shareImg = image;
//        _shareView.itemCount = 4;
//        [self.view.window addSubview:_shareView];
//    }
//    else {
//        [_shareView show];
//    }
}

- (void)createViews {
    UIView *view = [ZZViewHelper createWebView];
    view.backgroundColor = kBGColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        if (self.isCustomBlackNav) {
            make.top.offset(NAVIGATIONBAR_HEIGHT);
        }
        else{
            make.top.offset(0);
        }
    }];
    
    NSString *oAuthToken = XJUserAboutManageer.access_token;
//    if (!oAuthToken) {
//        oAuthToken = [ZZUserHelper shareInstance].publicToken;
//    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    if (self.isUploadToken) {
        [request setValue:oAuthToken forHTTPHeaderField:@"X-Api-Token"];
    }
    
    if (IOS8_OR_LATER) {
        _wkWebView = (WKWebView *)view;
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
            [self.wkWebView loadRequest:request ];
        }];
    }
    else {
        _webView = (UIWebView *)view;
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
            [self.webView loadRequest:request];
        }];
    }
    
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator startAnimating];
}

- (void)webViewSayHiAction {
    
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = request.URL;
    NSString *scheme = URL.absoluteString;
    NSLog(@"%@",scheme);

    if ([self isContainStingWithSumString:scheme]) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = URL.absoluteString;
    NSLog(@"%@",scheme);
    
    if ([self isContainStingWithSumString:scheme]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

- (BOOL)isContainStingWithSumString:(NSString *)string {
    string = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSRange range = [string rangeOfString:@"zwmscheme://"];
    if (range.location == NSNotFound) {
        if ([string isEqualToString:@"weixin://"]) {
            //判断是否安装了微信
            if (![WXApi isWXAppInstalled]) {
                [UIAlertController presentAlertControllerWithTitle:@"当前设备尚未安装微信" message:nil doneTitle:@"我知道了" cancelTitle:nil completeBlock:nil];
            }
            else{
                NSURL * url = [NSURL URLWithString:@"weixin://"];
                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
                //先判断是否能打开该url
                if (canOpen)
                {   //打开微信
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            return YES;
        }
        return NO;
    }
    else {
        return YES;
    }
   
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isHideNavigationBarWhenUp) {
        return;
    }
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat scale = 0;
    
    if (offset <= 0) {
        scale = 0;
    } else if (0 < offset && offset < NAVIGATIONBAR_HEIGHT) {
        scale = offset / NAVIGATIONBAR_HEIGHT;
    } else {
        scale = 1;
    }
    [self.navigationView setViewAlphaScale:scale];
}

- (ZZLinkWebNavigationView *)navigationView {
      __weak typeof(self) Weakself = self;;
    if (!_navigationView) {
        _navigationView = [[ZZLinkWebNavigationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVIGATIONBAR_HEIGHT)];
        _navigationView.touchLeft = ^{
            [Weakself leftBtnClick];
        };
        _navigationView.touchRight = ^{
            [Weakself rightBtnClick];
        };
    }
    return _navigationView;
}

- (void)dealloc {
    _webView.scrollView.delegate = nil;
    _wkWebView.scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
