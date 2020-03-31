//
//  XJLoginView.h
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZProtocalChooseView;
@protocol XJLoginViewDelegate <NSObject>

//选择区号
- (void)selectAreaCode;
//登录
- (void)nomalLogin;
//手机号
- (void)phoneText:(NSString *)phone;
//密码
- (void)passwordText:(NSString *)psword;


//验证码登录
@optional
- (void)msgLogin;


//忘记密码
@optional
- (void)forgetPassword;

//发送验证码
@optional
- (void)senLoginMsg:(UIButton *)btn;

//用户使用和隐私协议
- (void)clickUserProtocal;

//用户协议
- (void)clickUserPrivateProtocal;

- (void)agreeTheProtocol:(BOOL)isAgreed;

@end

@interface XJLoginView : UIView
@property (nonatomic, strong) ZZProtocalChooseView *protocolView;
@property(nonatomic,strong) UILabel *areaCodeLb;
@property(nonatomic,strong) UITextField *phoneTF;
@property(nonatomic,strong) UITextField *pswordTF;
@property(nonatomic,weak) id<XJLoginViewDelegate> delegate;
@property(nonatomic,assign) BOOL ismsgLogin;


@end


