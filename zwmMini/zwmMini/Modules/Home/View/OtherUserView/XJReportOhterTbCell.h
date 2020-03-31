//
//  XJReportOhterTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XJReportOhterTbCellBlock)(NSString *otherStr);
@interface XJReportOhterTbCell : UITableViewCell

@property(nonatomic,copy) XJReportOhterTbCellBlock block;

@end

NS_ASSUME_NONNULL_END
