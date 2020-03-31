//
//  XJSelectAreaCodeVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"
@class XJContryListModel;

@interface XJSelectAreaCodeVC : UIViewController

@property (nonatomic, copy) void(^selectedCode)(NSString *code);

@end

@protocol XJSelectAreaCodeSearchVCDelegate <NSObject>

- (void)selectAreaCode:(XJContryListModel *)selectedContryModel;

@end

@interface XJSelectAreaCodeSearchVC : UITableViewController

@property (nonatomic, weak) id<XJSelectAreaCodeSearchVCDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *areaCodeArray;

@end
