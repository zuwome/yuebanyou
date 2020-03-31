//
//  XJSelectGenderView.h
//  zwmMini
//
//  Created by Batata on 2018/11/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BoyBtnBlock)(void);
typedef void(^GirleBlock)(void);
typedef void(^sureBtnBlock)(void);


@interface XJSelectGenderView : UIView

@property(nonatomic,copy) BoyBtnBlock clickBoy;
@property(nonatomic,copy) GirleBlock clickgirl;
@property(nonatomic,copy) sureBtnBlock clicksure;


@end

NS_ASSUME_NONNULL_END
