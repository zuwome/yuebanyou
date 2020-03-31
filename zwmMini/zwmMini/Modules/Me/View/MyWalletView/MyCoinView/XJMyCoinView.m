//
//  XJMyCoinView.m
//  zwmMini
//
//  Created by Batata on 2018/12/5.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJMyCoinView.h"
#import "XJMyCoinCollectionViewCell.h"
#import "TYAttributedLabel.h"


static NSString *collectionIdentifier = @"mycoinCollectionidentifier";

@interface XJMyCoinView()<UICollectionViewDelegate,UICollectionViewDataSource,TYAttributedLabelDelegate>

@property(nonatomic,strong) UILabel *coninLb;
@property(nonatomic,strong) UIButton *coninDetailBtn;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSIndexPath *lastIndexPath;
@property(nonatomic,strong) XJCoinModel *mycoinModel;//余额
@property(nonatomic,strong) NSMutableArray *payDataArray;
@property(nonatomic,strong) XJPayCoinModel *seletpaymodel;
@property(nonatomic,strong) UIView *rechargeBtnView;
@property(nonatomic,strong) UIButton *rechargeBtn;
@property (nonatomic,strong) UIButton *payAgreementBtn;//充值协议
@property (nonatomic,strong) TYAttributedLabel *payAgreementLab;//充值协议


@end

@implementation XJMyCoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

        [self creatUI];
        
    }
    return self;
}


- (void)creatUI{
    
    [self.coninLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(53);
    }];
    [self.coninDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.coninLb);
        make.top.equalTo(self.coninLb.mas_bottom).offset(2);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coninDetailBtn.mas_bottom).offset(40);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(160);
    }];
    
    [self.rechargeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.collectionView.mas_bottom).offset(40);
        make.width.mas_equalTo(315);
        make.height.mas_equalTo(50);
    }];
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rechargeBtnView);
    }];
    [self.payAgreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rechargeBtn).offset(20);
        make.top.equalTo(self.rechargeBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(170);
    }];
    [self.payAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.payAgreementLab);
        make.right.equalTo(self.payAgreementLab.mas_left).offset(-10);
    }];
    
}


- (void)setUpCoinLabel:(XJCoinModel *)model{
    
    self.coninLb.text = [NSString stringWithFormat:@"%ld",model.mcoin];

}
- (void)setUpCollection:(NSMutableArray *)dataArray{
    self.payDataArray = dataArray;
    self.seletpaymodel = self.payDataArray.firstObject;
    [self.collectionView reloadData];
}

//充值
- (void)recharAction:(UIButton *)btn{
    
    NSLog(@"充值");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickRechargeWithPayModel:isAgreement:)]) {
        [self.delegate clickRechargeWithPayModel:self.seletpaymodel isAgreement:self.payAgreementBtn.selected];
    }
    
}
//我已阅读协议
- (void)payAgreementClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
}
#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        if ([linkStr isEqualToString:@"充值协议"]) {
            //跳转到充值协议
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickProtocal)]) {
                [self.delegate clickProtocal];
            }
            
        }//支付教程
        else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickCourse)]) {
                [self.delegate clickCourse];
            }
            
        }
    }
}

#pragma mark collectionViewDelegate dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-30-30)/3.f, 65);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);//（上、左、下、右）
}
#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 24.f;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.payDataArray.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XJMyCoinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XJMyCoinCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    BOOL isselect = NO;
    if (indexPath.item == 0) {
        isselect = YES;
    }
    [cell setUpContet:self.payDataArray[indexPath.item] isSelect:isselect];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.seletpaymodel = self.payDataArray[indexPath.item];
    XJMyCoinCollectionViewCell *cell = (XJMyCoinCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setUpContet:self.seletpaymodel isSelect:YES];
    if (self.lastIndexPath) {
        XJMyCoinCollectionViewCell *cell = (XJMyCoinCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.lastIndexPath];
        [cell setUpContet:self.payDataArray[self.lastIndexPath.item] isSelect:NO];
    }
    self.lastIndexPath = indexPath;
    
}


#pragma mark lazy
- (UILabel *)coninLb{
    
    if (!_coninLb) {
        _coninLb = [XJUIFactory creatUILabelWithFrame:CGRectZero addToView:self textColor:defaultBlack text:@"" font:defaultFont(44) textInCenter:YES];
    }
    return _coninLb;
    
}

- (UIButton *)coninDetailBtn{
    
    if (!_coninDetailBtn) {
        _coninDetailBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self backColor:defaultWhite nomalTitle:@"我的么币" titleColor:defaultBlack titleFont:defaultFont(17) nomalImageName:@"coinimg" selectImageName:@"" target:nil action:nil];
        [_coninDetailBtn setImage:GetImage(@"coinimg") forState:UIControlStateSelected];
        _coninDetailBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
        _coninDetailBtn.enabled = NO;
        
    }
    return _coninDetailBtn;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = defaultWhite;
        [_collectionView registerClass:[XJMyCoinCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
        
    }
    return _collectionView;
}
- (NSMutableArray *)payDataArray{
    if (!_payDataArray) {
        _payDataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _payDataArray;
}

- (UIView *)rechargeBtnView{
    
    if (!_rechargeBtnView) {
        
        _rechargeBtnView = [XJUIFactory creatUIViewWithFrame:CGRectZero addToView:self backColor:defaultWhite];
        CAGradientLayer *gradientLayer = [XJUIFactory creatGradientLayer:CGRectMake(0, 0, 315, 50)];
        [_rechargeBtnView.layer addSublayer:gradientLayer];
        _rechargeBtnView.layer.cornerRadius = 25;
        _rechargeBtnView.layer.masksToBounds = YES;
    }
    return _rechargeBtnView;
}
- (UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        
        _rechargeBtn = [XJUIFactory creatUIButtonWithFrame:CGRectZero addToView:self.rechargeBtnView backColor:defaultClearColor nomalTitle:@"充值" titleColor:defaultWhite titleFont:defaultFont(17) nomalImageName:nil selectImageName:nil target:self action:@selector(recharAction:)];
    }
    return _rechargeBtn;
    
}
-(UIButton *)payAgreementBtn {
    if (!_payAgreementBtn) {
        _payAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payAgreementBtn setImage:[UIImage imageNamed:@"btn_report_n"] forState:UIControlStateNormal];
        [_payAgreementBtn setImage:[UIImage imageNamed:@"reddago"] forState:UIControlStateSelected];
        _payAgreementBtn.selected = YES;
        [_payAgreementBtn addTarget:self action:@selector(payAgreementClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_payAgreementBtn];
    }
    return _payAgreementBtn;
}


- (TYAttributedLabel *)payAgreementLab {
    if (!_payAgreementLab) {
        _payAgreementLab =[[TYAttributedLabel alloc]initWithFrame:CGRectZero];
        _payAgreementLab.textAlignment = kCTTextAlignmentLeft;
        _payAgreementLab.textColor= RGB(128, 128, 128);
        
        _payAgreementLab.font= [UIFont systemFontOfSize:12];
        _payAgreementLab.text = @"我已阅读并同意";
        _payAgreementLab.delegate = self;
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"《充值协议》" attributes:@{NSForegroundColorAttributeName: RGB(255, 87, 103), NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
//
//        [attributedString addAttribute:NSLinkAttributeName
//                                 value:@"zhifubao://"
//                                 range:[[attributedString string] rangeOfString:@"《支付宝协议》"]];
        
        [_payAgreementLab appendTextAttributedString:string];
        [_payAgreementLab addLinkWithLinkData:@"充值协议" linkColor:UIColor.redColor underLineStyle:kCTUnderlineStyleNone range:[_payAgreementLab.text rangeOfString:@"《充值协议》"]];
//        [ _payAgreementLab appendLinkWithText:@"《充值协议》" linkFont:[UIFont systemFontOfSize:12 ] linkColor: RGB(255, 186, 0) underLineStyle:kCTUnderlineStyleNone linkData:@"充值协议"];
//        _payAgreementLab.linkColor = RGB(255, 87, 103);
//        [ _payAgreementLab appendLinkWithText:@"|  苹果支付教程" linkFont:[UIFont systemFontOfSize:12 ] linkColor: RGB(128, 128, 128) underLineStyle:kCTUnderlineStyleNone linkData:@"苹果支付教程"];
        [self addSubview:_payAgreementLab];
    }
    return _payAgreementLab;
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
