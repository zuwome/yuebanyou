//
//  XJSearchAccountView.h
//  zwmMini
//
//  Created by Batata on 2018/11/22.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol XJSearchAccountViewDelegate <NSObject>

- (void)seachText:(NSString *)text;

@end
@interface XJSearchAccountView : UIView

@property(nonatomic,weak) id<XJSearchAccountViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
