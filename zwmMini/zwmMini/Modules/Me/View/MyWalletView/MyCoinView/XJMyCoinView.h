//
//  XJMyCoinView.h
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJCoinModel.h"
#import "XJPayCoinModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol XJMyCoinViewDelegate <NSObject>

- (void)clickRechargeWithPayModel:(XJPayCoinModel *)payModel isAgreement:(BOOL)agree;
- (void)clickProtocal;
- (void)clickCourse;

@end

@interface XJMyCoinView : UIView
- (void)setUpCoinLabel:(XJCoinModel *)model;
- (void)setUpCollection:(NSMutableArray *)dataArray;
@property(nonatomic,weak) id<XJMyCoinViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
