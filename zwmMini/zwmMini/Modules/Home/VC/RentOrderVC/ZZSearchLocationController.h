//
//  ZZSearchLocationController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJBaseVC.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ZZRentDropdownModel.h"

@interface ZZSearchLocationController : XJBaseVC

@property (nonatomic, strong) XJCityModel *currentSelectCity;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) void (^presentBlock)(void);

@property (nonatomic, copy) void (^selectPoiDone)(ZZRentDropdownModel *model);

@property (nonatomic, assign) BOOL isFromTaskFree;

- (instancetype)initWithSelectCity:(XJCityModel *)city;

@end
//
@interface ZZLocationAlertView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end
