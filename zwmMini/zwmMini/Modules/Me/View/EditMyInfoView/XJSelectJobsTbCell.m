//
//  XJSelectJobsTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSelectJobsTbCell.h"

@interface XJSelectJobsTbCell()



@end

@implementation XJSelectJobsTbCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titileLb.backgroundColor =  RGB(255, 233, 237);
    }
    return self;
    
}

- (void)setUpJobsTitle:(NSString *)title andIndexPath:(NSIndexPath *)indexpath{
    
    self.titileLb.text = title;

    
}

- (UILabel *)titileLb{
    
    if (!_titileLb) {
        _titileLb = [XJUIFactory creatUILabelWithFrame:CGRectMake(0, 0, 78, 44) addToView:self.contentView textColor:defaultBlack text:@"" font:defaultFont(15) textInCenter:YES];
    }
    return _titileLb;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
