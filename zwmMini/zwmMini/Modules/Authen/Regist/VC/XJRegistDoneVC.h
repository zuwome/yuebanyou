//
//  XJRegistDoneVC.h
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJRegistDoneVC : XJBaseVC
@property(nonatomic,assign) BOOL isBoy;
@property(nonatomic,assign) BOOL isSkip;
@property(nonatomic,copy) NSString *faceUrl;
@property(nonatomic,copy) NSDictionary *para;
@end

NS_ASSUME_NONNULL_END
