//
//  XJRestPasswordView.h
//  zwmMini
//
//  Created by Batata on 2018/11/22.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJRestPasswordDelegate <NSObject>

//重置密码
- (void)resetPassword;
//验证码
- (void)msgText:(NSString *)msgcode;
//密码
- (void)passwordnText:(NSString *)newpsword;

//发送验证码

- (void)senLoginMsg:(UIButton *)btn;

@end


@interface XJRestPasswordView : UIView

@property(nonatomic,weak) id<XJRestPasswordDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
