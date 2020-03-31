//
//  XJReportOhterTbCell.m
//  zwmMini
//
//  Created by Batata on 2018/12/21.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJReportOhterTbCell.h"

@interface XJReportOhterTbCell()<UITextViewDelegate>

@property(nonatomic,strong) UITextView *myIntriduceTf;
@property(nonatomic,strong) UILabel *explainLb;
@property(nonatomic,strong) UILabel *numberLb;

@end

@implementation XJReportOhterTbCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = defaultWhite;

        [self.contentView addSubview:self.myIntriduceTf];
        [self.myIntriduceTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.bottom.equalTo(self.contentView).offset(-40);
           
        }];
        [self.explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myIntriduceTf.mas_bottom).offset(10);
            make.left.equalTo(self.myIntriduceTf);
            make.bottom.equalTo(self.contentView);
        }];
        [self.numberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.explainLb);
            make.right.equalTo(self.myIntriduceTf);
            make.bottom.equalTo(self.contentView);

        }];
    }
    return self;
    
    
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.block) {
        self.block(textView.text);
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.numberLb.text = [NSString stringWithFormat:@"%lu/80",range.location+1];
    if (range.location >79) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self.contentView endEditing:YES];
        return NO;
    }
    
    return YES;
    
}

- (UITextView *)myIntriduceTf{
    
    if (!_myIntriduceTf) {
        
        _myIntriduceTf = [[UITextView alloc] init];
//        _myIntriduceTf.frame = CGRectMake(15, 10, kScreenWidth-30, 150);
        _myIntriduceTf.textAlignment = NSTextAlignmentLeft;
        _myIntriduceTf.textColor = defaultBlack;
        _myIntriduceTf.font = [UIFont systemFontOfSize:15];
        _myIntriduceTf.delegate = self;
        _myIntriduceTf.layer.cornerRadius = 5;
        _myIntriduceTf.layer.masksToBounds = YES;
        _myIntriduceTf.returnKeyType = UIReturnKeyDone;
        
    }
    return _myIntriduceTf;
    
}

- (UILabel *)explainLb{
    
    if (!_explainLb) {
        _explainLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"请输入其他原因" font:defaultFont(13) textInCenter:NO];
    }
    return _explainLb;
    
    
}
- (UILabel *)numberLb{
    
    if (!_numberLb) {
        _numberLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.contentView textColor:defaultGray text:@"0/80" font:defaultFont(13) textInCenter:NO];
        _numberLb.textAlignment = NSTextAlignmentRight;
    }
    return _numberLb;
    
    
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
