//
//  XJLookoverOtherUserVC.h
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface XJLookoverOtherUserVC : XJBaseVC
@property(nonatomic,strong) XJUserModel *topUserModel;

@property (nonatomic, assign) BOOL shouldLookForWx;
- (void)lookoverWx;

@end

NS_ASSUME_NONNULL_END
