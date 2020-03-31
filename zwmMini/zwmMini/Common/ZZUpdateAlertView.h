//
//  ZZUpdateAlertView.h
//  zuwome
//
//  Created by angBiu on 2017/6/15.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZUpdateAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame upgradeTips:(NSDictionary *)tips;

- (void)configureInfos:(NSDictionary *)infos;

@end
