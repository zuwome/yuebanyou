//
//  XJSelectJbosCollectionViewCell.h
//  zwmMini
//
//  Created by Batata on 2018/11/29.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface XJSelectJbosCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) UILabel *titileLb;


- (void)setUpSubJobsDic:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath isSelect:(BOOL )select;
@end

NS_ASSUME_NONNULL_END
