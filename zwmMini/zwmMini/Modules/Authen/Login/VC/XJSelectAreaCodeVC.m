//
//  XJSelectAreaCodeVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/14.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSelectAreaCodeVC.h"


#import "XJContryListModel.h"
#import "XJSelectAreaTbCell.h"


#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface XJSelectAreaCodeVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate, XJSelectAreaCodeSearchVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//总的数据
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索的数据
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) XJSelectAreaCodeSearchVC *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation XJSelectAreaCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择国家或地区";
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self loadData];
    [self createNavigationLeftBar];
    
}

- (void)createNavigationLeftBar
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    
    [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems =@[leftItem];

}

- (void)navigationLeftBtnClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)initSearchDisplay {
    _searchResultTableVC = [[XJSelectAreaCodeSearchVC alloc] init];
    _searchResultTableVC.areaCodeArray = _dataArray;
    _searchResultTableVC.delegate = self;

    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;

    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)selectAreaCode:(XJContryListModel *)selectedContryModel {
    if (_selectedCode) {
        _selectedCode(selectedContryModel.code);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Data
- (void)loadData
{
   
    [MBManager showLoading];
    [AskManager GET:API_CONUTRY_LIST_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            for (NSDictionary *aDict in data) {
                
                NSString *key = [[aDict allKeys] firstObject];
                [self.indexArray addObject:key];
                
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
                for (NSDictionary *temdic in aDict[key]) {
                    
                    XJContryListModel *cmodel = [XJContryListModel yy_modelWithDictionary:temdic];
                    [array addObject:cmodel];
                }
                [self.dataArray addObject:array];
            }
            
            [self.view addSubview:self.tableView];
//            [self.view addSubview:self.searchBar];
            
            
        }else{
            
            
            
        }
        
        [MBManager hideAlert];
        
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];
        
    }];
    
}


#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        NSArray *array = self.dataArray[section];
        return array.count;
    } else {
        return self.searchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    XJSelectAreaTbCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[XJSelectAreaTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (tableView == _tableView) {
        NSArray *array = self.dataArray[indexPath.section];
        XJContryListModel *model = array[indexPath.row];
        cell.model = model;
    } else {
        XJContryListModel *model = self.searchArray[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return self.indexArray;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XJContryListModel *model = [[XJContryListModel alloc] init];
    if (tableView == _tableView) {
        NSArray *array = self.dataArray[indexPath.section];
        model = array[indexPath.row];
    } else {
        model = self.searchArray[indexPath.row];
    }
    if (_selectedCode) {
        _selectedCode(model.code);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchWithSearchString:searchBar.text];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchWithSearchString:searchString];
    return YES;
}

- (void)searchWithSearchString:(NSString *)string
{
    [self.searchArray removeAllObjects];
    
    if (string.length > 0 && _dataArray.count) {
        if (![ChineseInclude isIncludeChineseInString:string]) {
            for (int i=0; i<_dataArray.count; i++) {
                NSArray *array = _dataArray[i];
                for (XJContryListModel *model in array) {
                    if ([ChineseInclude isIncludeChineseInString:model.name]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:model.name];
                        NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:model];
                        }
                        
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:model.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        
                        if (titleHeadResult.length>1) {
                            [_searchArray addObject:model];
                        }
                    } else {
                        NSRange titleResult=[model.name rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:model];
                        }
                    }
                }
            }
        } else {
            for (int i=0; i<_dataArray.count; i++) {
                NSArray *array = _dataArray[i];
                for (XJContryListModel *model in array) {
                    NSRange titleResult=[model.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchArray addObject:model];
                    }
                }
            }
        }
    }
}

#pragma mark - Lazyload
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - SafeAreaTopHeight - 44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexColor = defaultWhite;
        _tableView.sectionIndexMinimumDisplayRowCount = 40;
        
        [self initSearchDisplay];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)indexArray{
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

@end



@interface XJSelectAreaCodeSearchVC ()

@end


@implementation XJSelectAreaCodeSearchVC
{
    // 搜索结果数组
    NSMutableArray *_searchResultArray;
}

- (void)searchWithSearchString:(NSString *)string {
    [_searchResultArray removeAllObjects];
    
    if (string.length > 0 && _areaCodeArray.count) {
        if (![ChineseInclude isIncludeChineseInString:string]) {
            for (int i=0; i<_areaCodeArray.count; i++) {
                NSArray *array = _areaCodeArray[i];
                for (XJContryListModel *model in array) {
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
        } else {
            for (int i=0; i<_areaCodeArray.count; i++) {
                NSArray *array = _areaCodeArray[i];
                for (XJContryListModel *model in array) {
                    NSRange titleResult=[model.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchResultArray addObject:model];
                    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"namecell";
    
    XJSelectAreaTbCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XJSelectAreaTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XJContryListModel *model = _searchResultArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(selectAreaCode:)]) {
        [self.delegate selectAreaCode:_searchResultArray[indexPath.row]];
    }
    
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
