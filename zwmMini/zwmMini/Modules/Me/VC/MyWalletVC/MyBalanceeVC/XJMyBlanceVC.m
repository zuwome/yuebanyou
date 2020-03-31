//
//  XJMyBlanceVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyBlanceVC.h"
#import "XJCoinModel.h"
#import "XJMyBalanceHeadView.h"
#import <WebKit/WebKit.h>
#import "XJWithDrawVC.h"
#import "XJCheckingFaceVC.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "XJUploadRealHeadImgVC.h"
#import "XJRealNameAutoVC.h"
@interface XJMyBlanceVC ()<WKNavigationDelegate, WKUIDelegate, UINavigationControllerDelegate, UINavigationBarDelegate>

@property(nonatomic,strong) XJCoinModel *mycoinModel;//余额
@property(nonatomic,strong) XJMyBalanceHeadView *headView;
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIView *webBgView;
@property(nonatomic,strong) WKWebView *webView;

@end

@implementation XJMyBlanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收入余额";
    [self creatUI];
    [self getCoinBalanceData];
//    [self getHintHtmlStr];
}

- (void)withDarwAction{
//    [self showAlerVCtitle:@"提示" message:@"请升级到空虾,在申请提现" sureTitle:@"立即升级" cancelTitle:@"取消" sureBlcok:^{
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1471612125"]];
//    }  cancelBlock:^{
//
//    }];
    
    if (![self isIdentifer]) {
            if (XJUserAboutManageer.uModel.faces.count == 0) {
             //去人脸识别
            [self showAlerVCtitle:@"提现需验证人脸" message:@"" sureTitle:@"确定" cancelTitle:@"取消" sureBlcok:^{

                        XJCheckingFaceVC* lvc = [[XJCheckingFaceVC alloc] init];
                        [lvc livenesswithList:@[@(0),@(4),@(6)] order:YES numberOfLiveness:3];
                        //                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
                        [self presentViewController:lvc animated:YES completion:nil];
                        lvc.endBlock = ^(UIImage * _Nonnull bestImg) {

                            [self checkIshack:bestImg];
                        };
                    } cancelBlock:^{
                }];
                return ;
            }
            XJPhoto *photo = XJUserAboutManageer.uModel.photos.firstObject;
            if (photo == nil || photo.face_detect_status != 3) {
                [self showAlerVCtitle:@"提现需要上传真实头像" message:@"" sureTitle:@"前往" cancelTitle:@"取消" sureBlcok:^{
                    //去上传真实头像

                    XJUploadRealHeadImgVC *upVC = [XJUploadRealHeadImgVC new];
                    [self.navigationController pushViewController:upVC animated:YES];
                    upVC.endBlock = ^{
                        [self withDarwAction];
                    };
                } cancelBlock:^{
                }];
                return;
            }
        //        [self showAlerVCtitle:@"提示" message:@"提现需实名认证，是否去认证?" sureTitle:@"认证" cancelTitle:@"取消" sureBlcok:^{
        [self  showAlerVCtitle:@"提示" message:@"提现需实名认证，是否去认证?" sureTitle:@"认证" cancelTitle:@"取消" sureBlcok:^{
            [self.navigationController pushViewController:[XJRealNameAutoVC new] animated:YES];
        } cancelBlock:^{
        }];
        return;
    }
    XJWithDrawVC *withDrawVC = [XJWithDrawVC new];
    withDrawVC.mycoinModel = self.mycoinModel;
    [self.navigationController pushViewController:withDrawVC animated:YES];
}

- (void)checkIshack:(UIImage *)bestimg{
    [MBManager showWaitingWithTitle:@"验证人脸中..."];
    [XJUploader uploadImage:bestimg progress:^(NSString *key, float percent) {
    } success:^(NSString * _Nonnull url) {
        
        [AskManager POST:API_PHOTOT_IS_HACK_POST dict:@{@"image_best":url}.mutableCopy succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                
                NSString *isHack = data[@"isHack"];
                if ([isHack isEqualToString:@"true"]) {
                    [self showAlerVCtitle:@"检测失败" message:@"" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                        
                    } cancelBlock:^{
                        
                    }];
                    
                }else{
                    
                    [self pushFaces:url];
                    
                }
                
                
            }else{
                
                [self showAlerVCtitle:@"检测失败" message:@"" sureTitle:@"确定" cancelTitle:@"" sureBlcok:^{
                    
                } cancelBlock:^{
                    
                }];
                
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
        [MBManager hideAlert];
    } failure:^{
        [MBManager hideAlert];
    }];
}
//更新face到服务器
- (void)pushFaces:(NSString *)url{
    
    NSArray *urlArr = @[url];
    [AskManager POST:API_UPDATA_JOBS dict:@{@"faces":urlArr}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            XJUserModel *umodel = [XJUserModel yy_modelWithDictionary:data];
            XJUserAboutManageer.uModel = umodel;
            
            [self withDarwAction];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}


- (BOOL)isIdentifer{
    
    
    if (XJUserAboutManageer.uModel.realname.status == 2) {
        return YES;
    }
    if (XJUserAboutManageer.uModel.realname_abroad.status == 2) {
        return YES;
    }
    return NO;
}
- (void)creatUI{
    
    [self showNavRightButton:@"提现" action:@selector(withDarwAction) image:nil imageOn:nil];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.whiteView];
    [self.view addSubview:self.webBgView];
    [self.webBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.webBgView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.webBgView);
        make.left.equalTo(self.webBgView).offset(15);
        make.right.equalTo(self.webBgView).offset(-15);
    }];


}
//获取余额
- (void)getCoinBalanceData{
    
    [MBManager showLoading];
    [AskManager GET:API_MY_COIN_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            self.mycoinModel = [XJCoinModel yy_modelWithDictionary:data];
            self.headView.model = self.mycoinModel;
        }
        [MBManager hideAlert];
    } failure:^(NSError *error) {
        [MBManager hideAlert];

    }];
    
}
- (void)getHintHtmlStr{
    [AskManager GET:API_MYBALANCE_HINT_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            [self.webView loadHTMLString:data[@"enhance_income_tip"] baseURL:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark webviewdelegate
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler;{
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}


- (void)webView:(WKWebView*)webView decidePolicyForNavigationResponse:(WKNavigationResponse*)navigationResponse decisionHandler:(void(^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'" completionHandler:nil];
}
    
   
#pragma mark lazy

- (XJMyBalanceHeadView *)headView{
    
    if (!_headView) {
        _headView = [[XJMyBalanceHeadView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth, 175)];
    }
    return _headView;
    
}

- (UIView *)whiteView{
    if (!_whiteView) {
        
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 187, kScreenWidth, 10)];
        _whiteView.backgroundColor = defaultWhite;
    }
    return _whiteView;
    
}
- (UIView *)webBgView{
    if (!_webBgView) {
        
        _webBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _webBgView.backgroundColor = defaultWhite;
    }
    return _webBgView;
    
}
- (WKWebView *)webView{
    
    if (!_webView) {
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        //    wkWebConfig.userContentController = wkUController;
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        // 设置字体大小(最小的字体大小)
        preference.minimumFontSize = 15.f;
        // 设置偏好设置对象
        wkWebConfig.preferences = preference;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _webView.navigationDelegate = self;
        
    }
    
    return _webView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
