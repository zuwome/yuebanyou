//
//  ZZRentPayCompleteChatCell.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "XJTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@class ZZRentPayCompleteChatCell;
@class ZZOrder;
@protocol ZZRentPayCompleteChatCellDelegate <NSObject>

- (void)cellGoChat:(ZZRentPayCompleteChatCell *)cell;

@end

@interface ZZRentPayCompleteChatCell : XJTableViewCell

@property (nonatomic, strong) ZZOrder *order;

@property (nonatomic, weak) id<ZZRentPayCompleteChatCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
