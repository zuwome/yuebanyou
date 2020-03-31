//
//  ZZCityViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

/**
 *  首页左上角选择城市
 */
@class XJCityModel;
@interface ZZCityViewController : UIViewController

@property (nonatomic, copy) void(^selectCity)(NSString *cityName);

@end

@protocol ZZCitySearchViewControllerDelegate <NSObject>

- (void)selectCity:(XJCityModel *)city;

@end

@interface ZZCitySearchViewController : UITableViewController

@property (nonatomic, weak) id<ZZCitySearchViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *cityArray;

@end
