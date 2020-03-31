//
//  XJCoinModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJCoinModel : NSObject

@property(nonatomic,assign) NSInteger mcoin;
@property(nonatomic,assign) NSInteger mcoin_total;
@property(nonatomic,assign) float frozen;
@property(nonatomic,assign) float balance;


@end

NS_ASSUME_NONNULL_END
