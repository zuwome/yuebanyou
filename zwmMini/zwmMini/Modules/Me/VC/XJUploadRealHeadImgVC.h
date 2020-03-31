//
//  XJUploadRealHeadImgVC.h
//  zwmMini
//
//  Created by Batata on 2018/12/17.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UploadHeadImgEndBlock)(void);
@interface XJUploadRealHeadImgVC : XJBaseVC

@property(nonatomic,copy) UploadHeadImgEndBlock endBlock;
@end

NS_ASSUME_NONNULL_END
