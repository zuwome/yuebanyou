//
//  UIViewController+XJShowSeletcController.m
//  zwmMini
//
//  Created by Batata on 2018/12/24.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "UIViewController+XJShowSeletcController.h"

@implementation UIViewController (XJShowSeletcController)

+ (UIViewController *)currentDisplayViewController {
    __kindof __block UIViewController *viewController = nil;
//    dispatch_async(dispatch_get_main_queue(), ^{
        viewController = [self findCurrentDisplayViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//    });
    return viewController;
}

+ (UIViewController *)findCurrentDisplayViewController:(UIViewController *)rootViewController {
    UIViewController *currentVC;
    
    if ([rootViewController presentedViewController]) {
        // 视图是被presented出来的
        rootViewController = [rootViewController presentedViewController];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self findCurrentDisplayViewController:[(UITabBarController *)rootViewController selectedViewController]];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        // 根视图为UINavigationController
        currentVC = [self findCurrentDisplayViewController:[(UINavigationController *)rootViewController visibleViewController]];
    }
    else {
        // 根视图为非导航类
        currentVC = rootViewController;
    }
    
    return currentVC;
}


- (void)showAlerVCtitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)suretitle cancelTitle:(NSString *)cancelTitle sureBlcok:(void(^)(void))sure cancelBlock:(void(^)(void))cancel
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:suretitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        sure();
        
    }];
    if (!NULLString(cancelTitle)) {
        UIAlertAction *cance = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancel();
        }];
        [alertController addAction:cance];
        
    }
    
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:^{ }];
}


+ (UIViewController *)visibleViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *visibleViewController = [rootViewController visibleViewControllerIfExist];
    return visibleViewController;
}

- (UIViewController *)visibleViewControllerIfExist {
    
    if (self.presentedViewController) {
        return [self.presentedViewController visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).topViewController visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController visibleViewControllerIfExist];
    }
    
    if ([self isViewLoaded] && self.view.window) {
        return self;
    } else {
        NSLog(@"visibleViewControllerIfExist:，找不到可见的viewController。self = %@, self.view.window = %@", self, self.view.window);
        return nil;
    }
}
@end
