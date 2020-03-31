//
//  XJSystemInfoTableViewCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/18.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSystemInfoTableViewCell.h"

@interface XJSystemInfoTableViewCell()

@property(nonatomic,strong) UIImageView *hintIV;
@property(nonatomic,strong) UILabel *timeLb;
@property(nonatomic,strong) UILabel *contentLb;
@property(nonatomic,strong) UIView *bgwhiteView;



@end


@implementation XJSystemInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = defaultLineColor;
        
        [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.hintIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.timeLb.mas_bottom).offset(15);
            make.width.height.mas_equalTo(46);
        }];
        
        [self.bgwhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hintIV);
            make.left.equalTo(self.hintIV.mas_right).offset(12);
            make.width.mas_equalTo(260);
            make.height.mas_greaterThanOrEqualTo(46);
        }];
        
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.bgwhiteView).offset(10);
            make.left.equalTo(self.bgwhiteView).offset(15);
            make.right.equalTo(self.bgwhiteView).offset(-15);
            make.bottom.equalTo(self.bgwhiteView).offset(-10);

        }];
        
        
    }
    return self;
    
}

- (void)setUpContent:(XJSystemMsgModel *)model{
    self.timeLb.text = [self UTCchangeDate:model.timeStamps];
    self.contentLb.text = model.content;
}

-(NSString *)UTCchangeDate:(NSString *)utc{
    NSTimeInterval time=[utc doubleValue] / 1000;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

#pragma mark lazy
- (UIImageView *)hintIV{
    
    if (!_hintIV) {
        _hintIV = [XJUIFactory creatUIImageViewWithFrame:CGRectZero addToView:self.contentView imageUrl:nil placehoderImage:@"systeminfoimg"];
        _hintIV.layer.cornerRadius = 23;
        _hintIV.layer.masksToBounds = YES;
        
    }
    return _hintIV;
    
}
- (UILabel *)timeLb{
    
    if (!_timeLb) {
        
        _timeLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"" font:defaultFont(13) textInCenter:YES];
    }
    return _timeLb;
    
    
}
- (UILabel *)contentLb{
    
    if (!_contentLb) {
        
        _contentLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bgwhiteView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
        _contentLb.backgroundColor = defaultWhite;
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
    
    
}

- (UIView *)bgwhiteView{
    
    if (!_bgwhiteView) {
        _bgwhiteView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self.contentView backColor:defaultWhite];
        _bgwhiteView.layer.cornerRadius = 6;
        _bgwhiteView.layer.masksToBounds = YES;
    }
    return _bgwhiteView;
    
    
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
