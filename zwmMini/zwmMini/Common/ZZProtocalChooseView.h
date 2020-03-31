//
//  ZZProtocalChooseView.h
//  zuwome
//
//  Created by angBiu on 2016/11/23.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZProtocalChooseView : UIView

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) dispatch_block_t touchProtocal;
@property (nonatomic, copy) dispatch_block_t touchPrivate;
@property (nonatomic, copy) void(^touchSelectedBlock)(BOOL isSeleceted);
@property (nonatomic, assign) BOOL isLogin;
- (instancetype)initWithFrame:(CGRect)frame isLogin:(BOOL)islogin;
@end
