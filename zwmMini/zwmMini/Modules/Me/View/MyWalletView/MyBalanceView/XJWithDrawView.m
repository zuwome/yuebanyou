//
//  XJWithDrawView.m
//  zwmMini
//
//  Created by Batata on 2018/12/6.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJWithDrawView.h"
#import "XJWithDrawSelectPayTypeTbCell.h"
#import "XJWithDarwInputMoneyTbCell.h"
#import "TYAttributedLabel.h"

static NSString *withdrawPaytypeIdentifier = @"withdrawpayIdentifier";
static NSString *WithdrawInputntifier = @"withdrawinputdentifier";

@interface XJWithDrawView()<UITableViewDelegate,UITableViewDataSource,XJWithDarwInputMoneyTbCellDelegate,TYAttributedLabelDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,copy) NSString *inputMoneyStr;
@property (nonatomic,strong) TYAttributedLabel *withDrawaLb;//提现规则
@property(nonatomic,strong) UILabel *balanceLb;



@end

@implementation XJWithDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

//全部提现
- (void)drawAllAction{
    
    self.inputMoneyStr = [NSString stringWithFormat:@"%.2f",self.coinModel.balance];
    [self.tableView reloadData];
}

//确认提现
- (void)sureAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureWithDrawMoney:)]) {
        [self.delegate sureWithDrawMoney:self.inputMoneyStr];
    }
    
}

- (void)moneyText:(NSString *)money{
    
    self.inputMoneyStr = money;
    
}
#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"提现规则"]) {
         
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickWithDarwProtocal)]) {
                [self.delegate clickWithDarwProtocal];
            }
            
        }
    }
}

#pragma mark tableviewDelegate and dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80.f;
    }
    return 130.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==  0) {
        XJWithDrawSelectPayTypeTbCell *cell = [tableView dequeueReusableCellWithIdentifier:withdrawPaytypeIdentifier];
        if (cell == nil) {
            cell = [[XJWithDrawSelectPayTypeTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawPaytypeIdentifier];
        }
        [cell setUpImage:@"wxpayimg" Title:@"提现到微信" isSelect:YES];
        
        return cell;
    }else{
        
        XJWithDarwInputMoneyTbCell *cell = [tableView dequeueReusableCellWithIdentifier:WithdrawInputntifier];
        if (cell == nil) {
            cell = [[XJWithDarwInputMoneyTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WithdrawInputntifier];
        }
        cell.delegate = self;
        [cell setUpInputFileText:self.inputMoneyStr];
        
        return cell;
        
    }
    
   
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark lzay
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self creatBottomView];
        [_tableView setTableFooterView:self.bottomView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
}
- (void)creatBottomView{
    
    
    [self.balanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(30);
        make.top.equalTo(self.bottomView).offset(12);
    }];
    
    UIButton *allDrawBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bottomView backColor:defaultWhite nomalTitle:@"全部提现" titleColor:RGB(1, 123, 255) titleFont:defaultFont(17) nomalImageName:nil selectImageName:nil target:self action:@selector(drawAllAction)];
    [allDrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-30);
        make.centerY.equalTo(self.balanceLb);
    }];
    
    UIButton *sureBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.bottomView backColor:defaultRedColor nomalTitle:@"确认提现" titleColor:defaultWhite titleFont:defaultFont(17) nomalImageName:nil selectImageName:nil target:self action:@selector(sureAction)];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(allDrawBtn.mas_bottom).offset(90);
        make.width.mas_equalTo(345);
        make.height.mas_equalTo(50);
    }];
    sureBtn.layer.cornerRadius = 25;
    sureBtn.layer.masksToBounds = YES;
    
    [self.withDrawaLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sureBtn);
        make.top.equalTo(sureBtn.mas_bottom).offset(5);
        make.height.mas_equalTo(100);
    }];
}

- (UILabel *)balanceLb{
    
    if (!_balanceLb) {
        
        _balanceLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self.bottomView textColor:defaultBlack text:@"" font:defaultFont(17) textInCenter:NO];
    }
    return _balanceLb;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 330)];
    }
    return _bottomView;
    
}
- (void)setCoinModel:(XJCoinModel *)coinModel{
    _coinModel = coinModel;
    self.balanceLb.text = [NSString stringWithFormat:@"可提现余额%.2f元",coinModel.balance];
}
- (TYAttributedLabel *)withDrawaLb {
    if (!_withDrawaLb) {
        
        NSString *name = NULLString(XJUserAboutManageer.uModel.realname.name) ? XJUserAboutManageer.uModel.realname_abroad.name : XJUserAboutManageer.uModel.realname.name;
        NSMutableString *disname = [[NSMutableString alloc] initWithString:name];
        [disname replaceCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        _withDrawaLb =[[TYAttributedLabel alloc]initWithFrame:CGRectZero];
        _withDrawaLb.textAlignment = kCTTextAlignmentCenter;
        _withDrawaLb.textColor= RGB(128, 128, 128);
        _withDrawaLb.numberOfLines = 0;
        _withDrawaLb.font= [UIFont systemFontOfSize:14];
        _withDrawaLb.text = [NSString stringWithFormat:@"只能提现到认证姓名为%@的微信上,最低50元/笔,详细请阅读",disname];
        _withDrawaLb.delegate = self;
        [ _withDrawaLb appendLinkWithText:@"提现规则" linkFont:[UIFont systemFontOfSize:14 ] linkColor:RGB(1, 123, 255) underLineStyle:kCTUnderlineStyleNone linkData:@"提现规则"];
        [self.bottomView addSubview:_withDrawaLb];
    }
    return _withDrawaLb;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
