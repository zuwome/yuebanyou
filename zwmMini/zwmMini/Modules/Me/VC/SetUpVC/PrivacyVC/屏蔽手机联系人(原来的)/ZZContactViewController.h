//
//  ZZContactViewController.h
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

/**
 *  设置 ---- 联系人
 */
@interface ZZContactViewController : UIViewController

@end

@class ZZContactSearchViewController;
@protocol ZZContactSearchViewControllerDelegate <NSObject>

- (void)controller:(ZZContactSearchViewController *)vc blockedArray:(NSMutableArray *)blockedArray;

@end

@interface ZZContactSearchViewController : UITableViewController

@property (nonatomic, weak) id<ZZContactSearchViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDictionary *contactPeopleDict;
@property (nonatomic, strong) NSArray *keysArray;;
@property (nonatomic, strong) NSMutableArray *blcokArray;//屏蔽的人
@end
