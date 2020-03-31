//
//  XJReportImgsTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/12/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJReportImgsTbCellDelegate <NSObject>

- (void)addImage:(UIButton *)btn;


@end

@interface XJReportImgsTbCell : UITableViewCell

@property(nonatomic,weak) id<XJReportImgsTbCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
