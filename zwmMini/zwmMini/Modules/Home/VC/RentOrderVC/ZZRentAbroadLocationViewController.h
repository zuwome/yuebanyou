//
//  ZZRentAbroadLocationViewController.h
//  zuwome
//
//  Created by angBiu on 2017/2/9.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "XJBaseVC.h"
#import "ZZRentDropdownModel.h"

/**
 国外城市
 */
@interface ZZRentAbroadLocationViewController : XJBaseVC
@property (nonatomic, strong) XJCityModel *currentSelectCity;
//@property (strong, nonatomic) ZZCity *city;
@property (copy,nonatomic) void(^selectPoiDone)(ZZRentDropdownModel *model);
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, assign) BOOL isFromTaskFree;

@end

@class ZZRentDropdownModel;

@protocol ZZRentAbroadLocationSearchViewControllerDelegate <NSObject>

- (void)setSelectedLocation:(ZZRentDropdownModel *)place;

@end

@interface ZZRentAbroadLocationSearchViewController : UITableViewController

@property (strong, nonatomic) XJCityModel *currentCity;

@property (nonatomic, assign) CLLocationCoordinate2D coordinates;

@property (nonatomic, assign) BOOL isFromTaskFree;

@property (nonatomic, weak) id<ZZRentAbroadLocationSearchViewControllerDelegate> delegate;

@end
