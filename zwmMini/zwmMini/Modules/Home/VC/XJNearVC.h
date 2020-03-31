//
//  XJNearVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/24.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"
#import "XJHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^XJNearVCBlock)(XJHomeListModel *homelistModel);

@interface XJNearVC : XJBaseVC
@property(nonatomic,copy) XJNearVCBlock block;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
