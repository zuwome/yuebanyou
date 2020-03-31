//
//  XJHomeListModel.h
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJHomeListModel : NSObject

@property (nonatomic, strong) NSString *sortValue;
@property (nonatomic, strong) NSString *current_star;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) XJUserModel *user;

@end

NS_ASSUME_NONNULL_END
