//
//  XJWithDrawView.h
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJCoinModel.h"
NS_ASSUME_NONNULL_BEGIN


@protocol XJWIthDarwViewDelegate <NSObject>

- (void)sureWithDrawMoney:(NSString *)money;

- (void)clickWithDarwProtocal;
@end

@interface XJWithDrawView : UIView

@property(nonatomic,weak) id<XJWIthDarwViewDelegate> delegate;
@property(nonatomic,strong) XJCoinModel *coinModel;

@end

NS_ASSUME_NONNULL_END
