//
//  UIViewController+XJShowSeletcController.h
//  zwmMini
//
//  Created by Batata on 2018/12/24.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XJShowSeletcController)

+ (__kindof UIViewController *)currentDisplayViewController;

+ (UIViewController *)visibleViewController;
- (void)showAlerVCtitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)suretitle cancelTitle:(NSString *)cancelTitle sureBlcok:(void(^)(void))sure cancelBlock:(void(^)(void))cancel;


@end

NS_ASSUME_NONNULL_END
