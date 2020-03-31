//
//  XJHomeTitleSelectView.h
//  zwmMini
//
//  Created by Batata on 2018/11/23.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJHomeTitleViewDlegate <NSObject>

- (void)clickRecommond;
- (void)clickNear;

@end

@interface XJHomeTitleSelectView : UIView

@property(nonatomic,weak) id<XJHomeTitleViewDlegate> delegate;

- (void)setBtnIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
