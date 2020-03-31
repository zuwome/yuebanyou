//
//  XJRegistDoneView.h
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJRegistDoneViewDelegate <NSObject>

- (void)clickHeadIV:(UIImageView *)IV;
- (void)clickDone;

- (void)nameText:(NSString *)name;
@optional
- (void)wechatText:(NSString *)wechat;

@end

@interface XJRegistDoneView : UIView

@property(nonatomic,assign) BOOL isBoy;
@property(nonatomic,weak) id<XJRegistDoneViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
