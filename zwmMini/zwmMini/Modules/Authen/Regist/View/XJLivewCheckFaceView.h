//
//  XJLivewCheckFaceView.h
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SkipBolock)(void);
typedef void(^BeginCheckBlock)(void);

@interface XJLivewCheckFaceView : UIView

@property(nonatomic,assign) BOOL isBoy;
@property(nonatomic,copy) SkipBolock clickSkip;
@property(nonatomic,copy) BeginCheckBlock clickBegin;

@end

NS_ASSUME_NONNULL_END
