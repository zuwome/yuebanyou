//
//  XJEditAgeVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJEditAgeVC.h"
#import "XJEditAgeTableViewCell.h"
#import "XJEditAgeTbBottomView.h"
#import "BRPickerView.h"
static NSString *tableIdentifier = @"editAgeTableviewidentifier";

@interface XJEditAgeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) NSMutableArray *contentArray;
@property(nonatomic,strong) NSDate *selectDate;
@property(nonatomic,strong) XJEditAgeTbBottomView *bottomView;

@property(nonatomic,copy) NSString *birthday;
@property(nonatomic,copy) NSString *con;
@property(nonatomic,assign) NSInteger age;


@end

@implementation XJEditAgeVC

- (instancetype)initWithAge:(NSInteger)age con:(NSString *)con birthday:(NSString *)birthday {
    self = [super init];
    if (self) {
        _age = age;
        _con = con;
        _birthday = birthday;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"年龄";
    [self showNavRightButton:@"" action:@selector(doneAction) image:GetImage(@"dagou") imageOn:GetImage(@"dagou")];
    [self.view addSubview:self.tableView];
}

- (void)doneAction {
    if (!self.selectDate) {
        [MBManager showBriefAlert:@"请选择生日"];
        return;
    }
    if (self.ageBlock) {
        self.ageBlock(self.selectDate,[NSString constellation:self.selectDate]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJEditAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[XJEditAgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    [cell setUpTitle:self.titleArray[indexPath.row] andContent:self.contentArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDate *minDate = [NSDate br_setYear:1900 month:1 day:1];
    NSDate *maxDate = [NSDate date];
    @WeakObj(self);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:XJUserAboutManageer.uModel.birthday];

    [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:dateStr minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
        @StrongObj(self);
        
        self.selectDate = [NSString nsstringConversionNSDate:selectValue];
        NSInteger age = [NSDate ageWithBirthday:self.selectDate];
        [self.contentArray replaceObjectAtIndex:1 withObject:[NSString constellation:self.selectDate]];
        [self.contentArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld",age]];
        [self.contentArray replaceObjectAtIndex:2 withObject:selectValue];
        [self.tableView reloadData];
    } cancelBlock:^{
        NSLog(@"点击了背景或取消按钮");
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , 150) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
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

- (XJEditAgeTbBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[XJEditAgeTbBottomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
    return _bottomView;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:10];
        [_titleArray addObjectsFromArray:@[@"年龄",@"星座",@"生日(点击选择)"]];
    }
    return _titleArray;
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithCapacity:10];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        
        NSDate *date = [NSString nsstringConversionNSDate:!NULLString(_birthday) ? _birthday: @"1990-01-01"];
        if (date) {
            _selectDate = date;
        }
//        NSInteger age = [NSDate ageWithBirthday:date];
//        NSString *constellation = [NSString constellation:self.selectDate];
        if (XJUserAboutManageer.uModel.age==0) {
            
        }
        NSString *agestr = _age==0 ? [NSString stringWithFormat:@"%ld",[NSDate ageWithBirthday:date]]:[NSString stringWithFormat:@"%ld",_age];
        NSString *constellation = NULLString(_con)? [NSString constellation:date]:_con;
        
        
        
        NSString *dateStr = [formatter stringFromDate:date];
        
        NSString *birthday =  dateStr ?: @"1990-01-01";//[NSDate ageWithBirthday:XJUserAboutManageer.uModel.birthday] == 0? @"请选择":[NSString stringWithFormat:@"%ld",(long)[NSDate ageWithBirthday:XJUserAboutManageer.uModel.birthday]];
        [_contentArray addObjectsFromArray:@[agestr,constellation,birthday]];
        
    }
    return _contentArray;
    
}

@end
