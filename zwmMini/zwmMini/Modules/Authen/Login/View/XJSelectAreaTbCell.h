//
//  XJSelectAreaTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJContryListModel.h"

@interface XJSelectAreaTbCell : UITableViewCell

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property(nonatomic,strong) XJContryListModel *model;

@end


