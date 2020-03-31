//
//  XJRegistView.h
//  zwmMini
//
//  Created by Batata on 2018/11/16.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol XJRegistViewDelegate <NSObject>


//选择区号
- (void)selectAreaCode;

//注册
- (void)nomalRegist;

//发送验证码
- (void)senLoginMsg:(UIButton *)btn;

//手机号
- (void)phoneText:(NSString *)phoneNum;

//验证码
- (void)msgcodText:(NSString *)msg;

//用户使用和隐私协议
- (void)clickUserProtocal;

//用户协议
- (void)clickUserPrivateProtocal;

- (void)agreeTheProtocol:(BOOL)isAgreed;

@end

@interface XJRegistView : UIView

@property(nonatomic,strong) UILabel *areaCodeLb;
@property(nonatomic,strong) UITextField *phoneTF;
@property(nonatomic,strong) UITextField *pswordTF;
@property(nonatomic,weak) id<XJRegistViewDelegate> delegate;
@property (nonatomic, assign) BOOL isLogin;

@end

NS_ASSUME_NONNULL_END
