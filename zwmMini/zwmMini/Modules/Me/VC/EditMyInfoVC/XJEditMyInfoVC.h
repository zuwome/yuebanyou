//
//  XJEditMyInfoVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XJEditMyInfoVCDelegate <NSObject>

- (void)editCompleet:(BOOL)isComplete;

@end

@interface XJEditMyInfoVC : XJBaseVC

@property (nonatomic, assign) BOOL gotoRootCtl;//pop时 是否回到 我 页面

@property (nonatomic, weak)id<XJEditMyInfoVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
