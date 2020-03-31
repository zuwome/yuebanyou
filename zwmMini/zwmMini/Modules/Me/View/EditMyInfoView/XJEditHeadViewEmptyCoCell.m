//
//  XJEditHeadViewEmptyCoCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditHeadViewEmptyCoCell.h"

@implementation XJEditHeadViewEmptyCoCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = defaultLineColor;
        
    }
    return self;
    
}
@end
