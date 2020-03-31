//
//  XJSelectJobsTbCell.h
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJSelectJobsTbCell : UITableViewCell

@property(nonatomic,strong) UILabel *titileLb;

- (void)setUpJobsTitle:(NSString *)title andIndexPath:(NSIndexPath *)indexpath;
@end

NS_ASSUME_NONNULL_END
