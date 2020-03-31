//
//  XJHasReviewListModel.h
//  zwmMini
//
//  Created by Batata on 2018/12/11.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHasReviewListModel : NSObject

@property(nonatomic,copy) NSString *id;
@property(nonatomic,strong) XJUserModel *user;
@property(nonatomic,copy) NSString *wechat_no;
@property(nonatomic,copy) NSString *sort_value;
@property(nonatomic,assign) float to_price;


@end

NS_ASSUME_NONNULL_END
