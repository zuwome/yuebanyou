//
//  XJMyHeadView.h
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJMyHeadViewDelegate <NSObject>

- (void)clickHeadIV;
- (void)editPersonalData;

@end

@interface XJMyHeadView : UIView

@property(nonatomic,weak) id<XJMyHeadViewDelegate> delegate;

- (void)setUpHeadViewInfo:(XJUserModel *)model;
@end

NS_ASSUME_NONNULL_END
