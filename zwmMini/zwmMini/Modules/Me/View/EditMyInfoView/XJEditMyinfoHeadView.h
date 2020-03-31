//
//  XJEditMyinfoHeadView.h
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XJEditMyinfoHeadViewDelegate <NSObject>

- (void)chaneIndexFrom:(NSInteger)fromIndex to:(NSInteger)toIndex;
- (void)clickPhoto:(NSInteger )index;
- (void)clickAddPhoto:(NSInteger )index;


@end

@interface XJEditMyinfoHeadView : UIView

@property(nonatomic,weak) id<XJEditMyinfoHeadViewDelegate> delegate;

- (void)setUpRefreshCollection:(NSArray *)phtotosArray;

@end

NS_ASSUME_NONNULL_END
