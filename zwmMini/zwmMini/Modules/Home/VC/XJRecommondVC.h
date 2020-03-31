//
//  XJRecommondVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"
#import "XJHomeListModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^XJRecommondVCBlock)(XJHomeListModel *homelistModel);

@interface XJRecommondVC : XJBaseVC
@property(nonatomic,copy) XJRecommondVCBlock block;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
