//
//  XJCheckingFaceVC.h
//  zwmMini
//
//  Created by Batata on 2018/12/16.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "FaceBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LiveCheckBlock)(UIImage *bestImg);
@interface XJCheckingFaceVC : FaceBaseViewController

@property(nonatomic,copy) LiveCheckBlock endBlock;
- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness;
@end

NS_ASSUME_NONNULL_END
