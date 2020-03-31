//
//  ZZContactViewController.m
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//c

#import "ZZContactViewController.h"

#import "ZZContactCell.h"
#import "ZZContactBottomBtnView.h"
#import "ZZContactAuthorityAlert.h"

#import "ZZContactModel.h"
#import "PPGetAddressBook.h"

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "ZZViewHelper.h"
#import "UIAlertView+Blocks.h"


#define WeakSelf __weak typeof(self)weakSelf = self;

@interface ZZContactViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, ZZContactSearchViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) ZZContactBottomBtnView *bottomView;
@property (nonatomic, strong) NSMutableArray *blcokArray;//屏蔽的人
@property (nonatomic, strong) NSDictionary *contactPeopleDict;
@property (nonatomic, strong) NSArray *keysArray;;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) ZZContactAuthorityAlert *alert;

@property (nonatomic, strong) ZZContactSearchViewController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ZZContactViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_alert) {
        [_alert removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"屏蔽手机联系人";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = defaultLineColor;
    [self getContactList];
}

- (void)initSearchDisplay {
    _searchResultTableVC = [[ZZContactSearchViewController alloc] init];
    _searchResultTableVC.keysArray = _keysArray;
    _searchResultTableVC.blcokArray = _blcokArray;
    _searchResultTableVC.contactPeopleDict = _contactPeopleDict;
    _searchResultTableVC.delegate = self;

    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;

    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)controller:(ZZContactSearchViewController *)vc blockedArray:(NSMutableArray *)blockedArray {
    _blcokArray = blockedArray;
    [self managerBottomViewStatus];
    [self.tableView reloadData];
    
}

- (void)getContactList
{
    WeakSelf;
    [[PPAddressBookHandle sharedAddressBookHandle] requestAuthorizationWithSuccessBlock:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf authorizeSuccess];
            });
            
        } else {
            if ([[UIDevice currentDevice].systemVersion integerValue] < 8) {
                [UIAlertView showWithTitle:NSLocalizedString(@"通讯录功能未开启", nil)
                                   message:NSLocalizedString(@"您尚未开启通讯录功能，请在设置-通知中心中，找到“租我吗”并打开通讯录来获取最完整的服务。",nil)
                         cancelButtonTitle:NSLocalizedString(@"确定", nil)
                         otherButtonTitles:nil
                                  tapBlock:nil];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.view.window addSubview:weakSelf.alert];
                });
            }
        }
    }];
}

- (void)authorizeSuccess
{
    WeakSelf;
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.frame = CGRectMake(0, 0, 80, 80);
    _indicator.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*0.5-80);
    _indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    _indicator.clipsToBounds = YES;
    _indicator.layer.cornerRadius = 6;
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
    
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        //装着所有联系人的字典
        weakSelf.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        weakSelf.keysArray = nameKeys;
        
        [weakSelf loadData];
        
        [self initSearchDisplay];
    } authorizationFailure:^{
        
        [weakSelf.indicator stopAnimating];
        [weakSelf.indicator removeFromSuperview];
        [MBManager showBriefAlert:@"无法访问通讯录"];
    }];
    
    
}

- (void)loadData
{
    ZZContactModel *model = [[ZZContactModel alloc] init];
    [model getContactBlockList:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        if (error) {

        } else {
            
            [self createViews];
            [_indicator stopAnimating];
            [_indicator removeFromSuperview];
            
            _blcokArray = [NSMutableArray arrayWithArray:data[@"phones"]];
            [self createBottomView];
            [_tableView reloadData];
        }
    }];
}

- (void)createViews
{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)createBottomView
{
    CGFloat bottomHeight = 50;
    
    CGFloat searchBarHeight = 44;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(searchBarHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-bottomHeight);
    }];
    
//    [self.view addSubview:self.searchBar];
    
//    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.top.mas_equalTo(self.view.mas_top);
//        make.height.mas_equalTo(@44);
//    }];
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
        make.height.mas_equalTo(bottomHeight);
    }];
    
    WeakSelf;
    self.bottomView.touchBottomView = ^{
        [weakSelf bottomViewClick];
    };
    
    [self managerBottomViewStatus];
}

- (NSMutableArray *)getAllPhoneArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<_keysArray.count; i++) {
        NSString *key = _keysArray[i];
        NSArray *peopleArray = [_contactPeopleDict objectForKey:key];
        for (int j=0; j<peopleArray.count; j++) {
            PPPersonModel *model = peopleArray[j];
            [model.mobileArray enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![array containsObject:phone]) {
                    [array addObject:phone];
                }
            }];
        }
    }
    
    return array;
}

- (void)managerBottomViewStatus
{
    NSMutableArray *array = [self getAllPhoneArray];
    
    __block BOOL isAll = YES;
    [array enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![_blcokArray containsObject:phone]) {
            isAll = NO;
            *stop = YES;
        }
    }];
    
    if (isAll) {
        [self bottomViewUnBlockStatus];
    } else {;
        [self bottomViewBlockStatus];
    }
}

- (void)bottomViewUnBlockStatus
{
    _bottomView.isPB = YES;
    _bottomView.titleLabel.text = @"取消屏蔽全部联系人";
    _bottomView.contentLabel.text = @"您的手机联系人将可以看到您的信息";
    _bottomView.backgroundColor = defaultLineColor;
    _bottomView.titleLabel.textColor = HEXCOLOR(0xff000b);
    _bottomView.contentLabel.textColor = HEXCOLOR(0x9b9b9b);
}

- (void)bottomViewBlockStatus
{
    _bottomView.isPB = NO;
    _bottomView.titleLabel.text = @"屏蔽全部联系人";
    _bottomView.contentLabel.text = @"屏蔽的联系人将无法看到你的任何信息";
    _bottomView.backgroundColor = kYellowColor;
    _bottomView.titleLabel.textColor = defaultBlack;
    _bottomView.contentLabel.textColor = HEXCOLOR(0x917907);
}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (tableView == _searchDisplayController.searchResultsTableView) {
//        return 1;
//    }
    return _keysArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == _searchDisplayController.searchResultsTableView) {
//        return _searchArray.count;
//    }
    NSString *key = _keysArray[section];
    return [_contactPeopleDict[key] count];
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return _keysArray[section];
//}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    if (tableView == _searchDisplayController.searchResultsTableView) {
//        return nil;
//    }
    return _keysArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PPPersonModel *people = [[PPPersonModel alloc] init];
//    if (tableView == _searchDisplayController.searchResultsTableView) {
//        people = _searchArray[indexPath.row];
//    } else {
        NSString *key = _keysArray[indexPath.section];
        people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
//    }
    
    cell.titleLabel.text = people.name;
    __block BOOL contain = NO;
    [people.mobileArray enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.blcokArray containsObject:phone]) {
            contain = YES;
            *stop = YES;
        }
    }];
    
    if (contain) {
        [cell.statusBtn setTitle:@"已屏蔽" forState:UIControlStateNormal];
        [cell.statusBtn setTitleColor:HEXCOLOR(0xADADB1) forState:UIControlStateNormal];
        cell.statusBtn.layer.borderColor = HEXCOLOR(0xADADB1).CGColor;
    } else {
        [cell.statusBtn setTitle:@"屏蔽" forState:UIControlStateNormal];
        [cell.statusBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        cell.statusBtn.layer.borderColor = kYellowColor.CGColor;
    }
    
    WeakSelf;
    cell.touchStatus = ^{
        [weakSelf statusBtnClick:people contain:contain];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (tableView == _searchDisplayController.searchResultsTableView) {
//        return 0.1;
//    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (tableView == _searchDisplayController.searchResultsTableView) {
//        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
//    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    UILabel *label = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:defaultBlack fontSize:17 text:_keysArray[section]];
    [headView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_left).offset(15);
        make.centerY.mas_equalTo(headView.mas_centerY);
    }];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
}

#pragma mark - UISearchDisplayDelegate
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
//        if([view isKindOfClass:[UIButton class]]) {
//            UIButton * cancel =(UIButton *)view;
//            [cancel setTitle:@"取消" forState:UIControlStateNormal];
//            [cancel setTitleColor:kYellowColor forState:UIControlStateNormal];
//        }
//    }
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchArray removeAllObjects];
    
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<_keysArray.count; i++) {
            NSString *key = _keysArray[i];
            NSArray *keyResultArray = _contactPeopleDict[key];
            for (int j=0; j<keyResultArray.count; j++) {
                PPPersonModel *model = keyResultArray[j];
                
                if ([ChineseInclude isIncludeChineseInString:model.name]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchArray addObject:model];
                    }
                    
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>1) {
                        [_searchArray addObject:model];
                    }
                } else {
                    NSRange titleResult=[model.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchArray addObject:model];
                    }
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<_keysArray.count; i++) {
            NSString *key = _keysArray[i];
            NSArray *keyResultArray = _contactPeopleDict[key];
            for (int j=0; j<keyResultArray.count; j++) {
                PPPersonModel *model = keyResultArray[j];
                NSRange titleResult=[model.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0){
                    [_searchArray addObject:model];
                }
            }
        }
    }
    
//    [_searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [_tableView reloadData];
}

#pragma mark - UIButtonMethod
- (void)statusBtnClick:(PPPersonModel *)model contain:(BOOL)contain {
    if (contain) {
        [self unblcokPhone:model.mobileArray];
    } else {
        [self blcokPhone:model.mobileArray];
    }
}

- (void)bottomViewClick {
    NSArray *array = [self getAllPhoneArray];
    if (_bottomView.isPB) {
        [self unblcokPhone:array];
    } else {
        [self blcokPhone:array];
    }
}

- (void)blcokPhone:(NSArray *)array {
    [MBManager showWaitingWithTitle:@"加载中..."];
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *param = @{@"contacts":string};
    ZZContactModel *model = [[ZZContactModel alloc] init];
    @WeakObj(self);
    [model blcokContact:param next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        @StrongObj(self);
        if (error) {
        } else {
            [MBManager showBriefAlert:@"已屏蔽"];
            [array enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.blcokArray addObject:phone];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
//                if ([self.searchBar isFirstResponder]) {
//                    [self.searchDisplayController.searchResultsTableView reloadData];
//                }
            });
            [self managerBottomViewStatus];
            [MBManager hideAlert];
        }
    }];
}

- (void)unblcokPhone:(NSArray *)array {
    [MBManager showWaitingWithTitle:@"加载中..."];
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *param = @{@"contacts":string};
    ZZContactModel *model = [[ZZContactModel alloc] init];
    @WeakObj(self);
    [model unblockContact:param next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        @StrongObj(self);
        if (error) {
        } else {
            [MBManager showBriefAlert:@"已取消屏蔽"];

            [array enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.blcokArray removeObject:phone];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
//                if ([self.searchBar isFirstResponder]) {
//                    [self.searchDisplayController.searchResultsTableView reloadData];
//                }
            });
            [self bottomViewBlockStatus];
            [MBManager hideAlert];

        }
    }];
}

#pragma mark - Lazyload
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = kYellowColor;
    }
    
    return _tableView;
}

//- (UISearchBar *)searchBar {
//    if (!_searchBar) {
//        _searchBar = [[UISearchBar alloc] init];
//        _searchBar.delegate = self;
//        _searchBar.placeholder = @"搜索";
//
//        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
//        _searchDisplayController.active = NO;
//        _searchDisplayController.delegate = self;
//        _searchDisplayController.searchResultsDataSource = self;
//        _searchDisplayController.searchResultsDelegate = self;
//    }
    
//    return _searchBar;
//}

- (ZZContactBottomBtnView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ZZContactBottomBtnView alloc] init];
    }
    
    return _bottomView;
}

- (ZZContactAuthorityAlert *)alert {
    if (!_alert) {
        _alert = [[ZZContactAuthorityAlert alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _alert;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface ZZContactSearchViewController ()

@end

@implementation ZZContactSearchViewController
{
    // 搜索结果数组
    NSMutableArray *_searchResultArray;
}

- (void)searchWithSearchString:(NSString *)string {
    [_searchResultArray removeAllObjects];
    
    if (string.length>0&&![ChineseInclude isIncludeChineseInString:string]) {
        for (int i=0; i<_keysArray.count; i++) {
            NSString *key = _keysArray[i];
            NSArray *keyResultArray = _contactPeopleDict[key];
            for (int j=0; j<keyResultArray.count; j++) {
                PPPersonModel *model = keyResultArray[j];
                
                if ([ChineseInclude isIncludeChineseInString:model.name]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchResultArray addObject:model];
                    }
                    
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                    
                    if (titleHeadResult.length>1) {
                        [_searchResultArray addObject:model];
                    }
                } else {
                    NSRange titleResult=[model.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchResultArray addObject:model];
                    }
                }
            }
        }
    } else if (string.length>0&&[ChineseInclude isIncludeChineseInString:string]) {
        for (int i=0; i<_keysArray.count; i++) {
            NSString *key = _keysArray[i];
            NSArray *keyResultArray = _contactPeopleDict[key];
            for (int j=0; j<keyResultArray.count; j++) {
                PPPersonModel *model = keyResultArray[j];
                NSRange titleResult=[model.name rangeOfString:string options:NSCaseInsensitiveSearch];
                if (titleResult.length>0){
                    [_searchResultArray addObject:model];
                }
            }
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self searchWithSearchString:searchController.searchBar.text];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    
    ZZContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PPPersonModel *people = [[PPPersonModel alloc] init];
    people = _searchResultArray[indexPath.row];
    
    cell.titleLabel.text = people.name;
    __block BOOL contain = NO;
    [people.mobileArray enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.blcokArray containsObject:phone]) {
            contain = YES;
            *stop = YES;
        }
    }];
    
    if (contain) {
        [cell.statusBtn setTitle:@"已屏蔽" forState:UIControlStateNormal];
        [cell.statusBtn setTitleColor:HEXCOLOR(0xADADB1) forState:UIControlStateNormal];
        cell.statusBtn.layer.borderColor = HEXCOLOR(0xADADB1).CGColor;
    } else {
        [cell.statusBtn setTitle:@"屏蔽" forState:UIControlStateNormal];
        [cell.statusBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        cell.statusBtn.layer.borderColor = kYellowColor.CGColor;
    }
    
    WeakSelf;
    cell.touchStatus = ^{
        [weakSelf statusBtnClick:people contain:contain];
    };
    
    return cell;
}

- (void)statusBtnClick:(PPPersonModel *)model contain:(BOOL)contain {
    if (contain) {
        [self unblcokPhone:model.mobileArray];
    } else {
        [self blcokPhone:model.mobileArray];
    }
}

- (void)blcokPhone:(NSArray *)array {
    [MBManager showWaitingWithTitle:@"加载中..."];
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *param = @{@"contacts":string};
    ZZContactModel *model = [[ZZContactModel alloc] init];
    @WeakObj(self);
    [model blcokContact:param next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        @StrongObj(self);
        if (error) {
        } else {
            [MBManager showBriefAlert:@"已屏蔽"];
            [array enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.blcokArray addObject:phone];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            [MBManager hideAlert];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(controller:blockedArray:)]) {
                [self.delegate controller:self blockedArray:self.blcokArray];
            }
        }
    }];
}

- (void)unblcokPhone:(NSArray *)array {
    [MBManager showWaitingWithTitle:@"加载中..."];
    NSString *string = [array componentsJoinedByString:@","];
    NSDictionary *param = @{@"contacts":string};
    ZZContactModel *model = [[ZZContactModel alloc] init];
    @WeakObj(self);
    [model unblockContact:param next:^(XJRequestError *error, id data, NSURLSessionDataTask *task) {
        @StrongObj(self);
        if (error) {
        } else {
            [MBManager showBriefAlert:@"已取消屏蔽"];

            [array enumerateObjectsUsingBlock:^(NSString *phone, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.blcokArray removeObject:phone];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            [MBManager hideAlert];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(controller:blockedArray:)]) {
                [self.delegate controller:self blockedArray:self.blcokArray];
            }
        }
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchResultArray = [NSMutableArray array];
    // 解决tableview无法正常显示的问题
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.definesPresentationContext = YES;
}



@end
