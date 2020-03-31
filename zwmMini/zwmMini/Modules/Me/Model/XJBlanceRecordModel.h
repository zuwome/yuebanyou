//
//  XJBlanceRecordModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJBlanceRecordModel : NSObject

@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *user;
@property(nonatomic,copy) NSString *skill;
@property(nonatomic,assign) float remain_money;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *order_id;
@property(nonatomic,copy) NSString *mmd_id;
@property(nonatomic,copy) NSString *sk_id;
@property(nonatomic,copy) NSString *created_at;
@property(nonatomic,assign) float amount;//花费
@property(nonatomic,copy) NSString *channel;


@end

NS_ASSUME_NONNULL_END
