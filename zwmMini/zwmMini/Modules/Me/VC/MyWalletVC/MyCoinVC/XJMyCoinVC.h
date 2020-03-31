//
//  XJMyCoinVC.h
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class XJMyCoinVC;

@protocol XJMyCoinVCDelegate <NSObject>

- (void)recharged:(XJMyCoinVC *)viewController;

@end

@interface XJMyCoinVC : XJBaseVC

@property (nonatomic,   weak) id<XJMyCoinVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
