//
//  ZZCityViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZCityViewController.h"
#import "ZZCityLocationCell.h"
#import "ZZCityNameCell.h"
#import "ZZCityHotCell.h"

#import <MapKit/MapKit.h>


#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface ZZCityViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,CLLocationManagerDelegate, ZZCitySearchViewControllerDelegate>
{
    NSMutableArray                      *_cityArray;//城市
    NSMutableArray                      *_indexArray;//索引
    CGFloat                             _hotCityHeight;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;//总的数据
@property (nonatomic, strong) NSString *currentCity;//定位cell显示的值
@property (nonatomic, assign) BOOL haveGotCity;//是否定位到城市
@property (nonatomic, strong) NSMutableArray *hotArray;//热门城市
@property (nonatomic, assign) BOOL requestLocation;
//@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArray;//搜索的数据
@property (nonatomic, assign) BOOL getLocatio;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *cloaction;

@property (nonatomic, strong) ZZCitySearchViewController *searchResultTableVC;

@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ZZCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hotArray = [NSMutableArray arrayWithCapacity:10];
    self.navigationItem.title = @"选择城市";
    [self getLocation];
    [self createViews];
    [self sendRequest];
}

- (void)createNavigationLeftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    
    [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems =@[leftItem];

}

- (void)navigationLeftBtnClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createViews {
    self.view.backgroundColor = UIColor.whiteColor;
    _currentCity = @"正在定位...";
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = HEXCOLOR(0xF4CB07);
    _tableView.sectionIndexMinimumDisplayRowCount = 40;
    [_tableView registerClass:[ZZCityHotCell class] forCellReuseIdentifier:@"hotcell"];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(56);
        make.bottom.mas_equalTo(self.view).with.offset(-SafeAreaBottomHeight);

    }];
    
    [self initSearchDisplay];
}

- (void)initSearchDisplay {
    _searchResultTableVC = [[ZZCitySearchViewController alloc] init];
    _searchResultTableVC.cityArray = _cityArray;
    _searchResultTableVC.delegate = self;

    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultTableVC];
    
    _searchController.searchResultsUpdater = _searchResultTableVC;

    [self.view addSubview:_searchController.searchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)selectCity:(XJCityModel *)city {
    if (_selectCity) {
        _selectCity(city.name);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SendRequest

- (void)getLocation {
    _requestLocation = NO;
    _currentCity = @"正在定位...";
    [_tableView reloadData];
    _getLocatio = NO;
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 100; //控制定位服务移动后更新频率。单位是“米”
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (_getLocatio) {
        return;
    }
    _getLocatio = YES;
//    [_locationManager stopUpdatingLocation];
//    [ZZUserHelper shareInstance].location = locations[0];
       _cloaction = [locations lastObject];
    XJUserAboutManageer.localLongitude = [NSString stringWithFormat:@"%lf",_cloaction.coordinate.longitude];
    XJUserAboutManageer.localLatitude = [NSString stringWithFormat:@"%lf",_cloaction.coordinate.latitude];
//    NSLog(@"%@",[NSString stringWithFormat:@"%lf",_cloaction.coordinate.longitude]);
    [self reverseGeocodeLocation];
}

- (void)reverseGeocodeLocation
{
    __block BOOL haveCity = NO;
    if (XJUserAboutManageer.cityName) {
        haveCity = YES;
    }
    __weak typeof(self)weakSelf = self;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
     CLLocation *location = [[CLLocation alloc] initWithLatitude:25.05 longitude:121.50];
    location = _cloaction;
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            weakSelf.currentCity = @"定位失败，重新获取";
        } else {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *cityName = @"";
            if (placemark.locality) {
                cityName = placemark.locality;
            } else if (placemark.administrativeArea) {
                cityName = placemark.administrativeArea;
            }
            if ([self isSpecailProvince:cityName]) {
                cityName = placemark.subLocality;
            }
            if (![placemark.ISOcountryCode isEqualToString:@"CN"]) {
                XJUserAboutManageer.isAbroad = YES;
                cityName = placemark.country;
            }
            [weakSelf.locationManager stopUpdatingLocation];

            if (!NULLString(cityName)) {
                XJUserAboutManageer.cityName = cityName;
                weakSelf.currentCity = cityName;
                weakSelf.haveGotCity = YES;
            } else {
                weakSelf.currentCity = @"定位失败，重新获取";
            }
            
        }
        weakSelf.requestLocation = YES;
        [weakSelf.tableView reloadData];
    }];
}

- (BOOL)isSpecailProvince:(NSString *)province
{
    if ([province isEqualToString:@"新疆维吾尔自治区"] || [province isEqualToString:@"海南省"] ||[province isEqualToString:@"湖北省"] ||[province isEqualToString:@"河南省"]) {
        return YES;
    }
    return NO;
}

- (void)sendRequest
{

    
    @WeakObj(self);
    [AskManager GET:API_CITY_LIST_GET dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        @StrongObj(self);
        if (!rError) {
            
            NSArray *array = data;
                        self.dataArray = [NSMutableArray arrayWithArray:array];
                        [self.dataArray removeObjectAtIndex:0];
            
            for (NSDictionary *dd in array[0][@"hot"]) {
                [self.hotArray addObject:[XJCityModel yy_modelWithDictionary:dd]];
            }
            [self managerHotCityHeight];
            [self managerIndex];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

            
        }else{
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)managerHotCityHeight
{
    CGFloat labelHeight = [XJUtils heightForCellWithText:@"哈哈哈" fontSize:14 labelWidth:MAXFLOAT] + 10;
    CGFloat width = 0;
    NSInteger count = 0;
    NSInteger yCount = 0;
    
    for (XJCityModel *city in _hotArray) {
        CGFloat labelWidth = [XJUtils widthForCellWithText:city.name fontSize:14] + 16;
        if (count == 0) {
            width = labelWidth;
        } else {
            width = width + labelWidth + 18;
        }
        if (width >= kScreenWidth - 30) {
            width = labelWidth;
            yCount++;
        }
        count++;
    }
    _hotCityHeight = 20 + labelHeight + (labelHeight + 13)*yCount;
}

- (void)managerIndex
{
    _indexArray = [NSMutableArray array];
    _cityArray = [NSMutableArray array];
    [_indexArray addObject:@"定位"];
    [_indexArray addObject:@"热门"];
    for (NSDictionary *aDict in _dataArray) {
        NSString *key = [[aDict allKeys] firstObject];
        [_indexArray addObject:key];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        
        for (NSDictionary *dd in aDict[key]) {
            [array addObject:[XJCityModel yy_modelWithDictionary:dd]];
        }
        
        
//        NSArray *array = [ZZCity arrayOfModelsFromDictionaries:[aDict objectForKey:key] error:nil];
        [_cityArray addObject:array];
    }
    
    _searchResultTableVC.cityArray = _cityArray;
}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        if (_cityArray) {
            return _indexArray.count;
        }
        return 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0 || section == 1) {
            return 1;
        }
        NSArray *array = _cityArray[section - 2];
        return array.count;
    } else {
        return _searchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    if (tableView == _tableView) {
        switch (indexPath.section) {
            case 0: {
                static NSString *identifier = @"locationcell";
                
                ZZCityLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ZZCityLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                
                cell.titleLabel.text = _currentCity;
                cell.selectCity = ^{
                    [weakSelf locationCitySelect];
                };
                
                return cell;
            }
                break;
            case 1:
            {
                ZZCityHotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotcell"];
                
                [self setupCell:cell];
                
                return cell;
            }
                break;
            default:
            {
                static NSString *identifier = @"namecell";
                
                ZZCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ZZCityNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                
                NSArray *array = _cityArray[indexPath.section - 2];
                XJCityModel *city = array[indexPath.row];
                cell.titleLabel.text = city.name;
                
                return cell;
            }
                break;
        }
    }
    else {
        static NSString *identifier = @"namecell";
        
        ZZCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZCityNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        XJCityModel *city = _searchArray[indexPath.row];
        cell.titleLabel.text = city.name;
        
        return cell;
    }
}

- (void)setupCell:(ZZCityHotCell *)cell {
    __weak typeof(self)weakSelf = self;
    [cell setData:_hotArray];
    
    cell.selectIndex = ^(NSInteger index) {
        XJCityModel *city = weakSelf.hotArray[index];
        if (weakSelf.selectCity) {
            weakSelf.selectCity(city.name);
        }
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            return 35;
        }
        if (indexPath.section == 1) {
            return _hotCityHeight;
        }
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headView.backgroundColor = HEXCOLOR(0xF5F5F5);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = defaultBlack;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [headView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_left).offset(15);
            make.centerY.mas_equalTo(headView.mas_centerY);
        }];
        
        if (section == 0) {
            titleLabel.text = @"定位";
        }
        else {
            titleLabel.text = _indexArray[section];
        }
        return headView;
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return 30;
    }
    else {
        return 0.1;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (_cityArray && tableView == _tableView) {
        return _indexArray;
    }
    else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        if (indexPath.section >= 2) {
            NSArray *array = _cityArray[indexPath.section - 2];
            XJCityModel *city = array[indexPath.row];
            if (_selectCity) {
                _selectCity(city.name);
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        XJCityModel *city = _searchArray[indexPath.row];
        if (_selectCity) {
            _selectCity(city.name);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

//选择定位城市
- (void)locationCitySelect {
    if (_haveGotCity) {
        if (_selectCity) {
            _selectCity(_currentCity);
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else if (_requestLocation) {
        [self getLocation];
    }
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

- (void)searchWithSearchString:(NSString *)string {
    [self.searchArray removeAllObjects];
    
    if (string.length > 0 && _cityArray.count) {
        if (![ChineseInclude isIncludeChineseInString:string]) {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (XJCityModel *city in array) {
                    if ([ChineseInclude isIncludeChineseInString:city.name]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:city.name];
                        NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:city];
                        }
                        
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:city.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        
                        if (titleHeadResult.length>1) {
                            [_searchArray addObject:city];
                        }
                    } else {
                        NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchArray addObject:city];
                        }
                    }
                }
            }
        } else {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (XJCityModel *city in array) {
                    NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchArray addObject:city];
                    }
                }
            }
        }
    }
    
//    [_displayController.searchResultsTableView reloadData];
}

- (void)dealloc{
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

#pragma mark - lazy

//- (UISearchBar *)searchBar{
//    if (!_searchBar) {
//        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
//        _searchBar.placeholder = @"输入城市名";
//        _searchBar.delegate = self;
//    }
//    return _searchBar;
//}

- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

@end


@interface ZZCitySearchViewController ()

@end

@implementation ZZCitySearchViewController
{
    // 搜索结果数组
    NSMutableArray *_searchResultArray;
}

- (void)searchWithSearchString:(NSString *)string {
    [_searchResultArray removeAllObjects];
    if (string.length > 0 && _cityArray.count) {
        if (![ChineseInclude isIncludeChineseInString:string]) {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (XJCityModel *city in array) {
                    if ([ChineseInclude isIncludeChineseInString:city.name]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:city.name];
                        NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchResultArray addObject:city];
                        }
                        
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:city.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                        
                        if (titleHeadResult.length>1) {
                            [_searchResultArray addObject:city];
                        }
                    } else {
                        NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                        if (titleResult.length>0) {
                            [_searchResultArray addObject:city];
                        }
                    }
                }
            }
        } else {
            for (int i=0; i<_cityArray.count; i++) {
                NSArray *array = _cityArray[i];
                for (XJCityModel *city in array) {
                    NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [_searchResultArray addObject:city];
                    }
                }
            }
        }
    }
    
//    if (string.length > 0 && _cityArray.count) {
//        if (![ChineseInclude isIncludeChineseInString:string]) {
//            for (int i=0; i<_cityArray.count; i++) {
//                NSArray *array = _cityArray[i];
//                for (ZZCity *city in array) {
//                    if ([ChineseInclude isIncludeChineseInString:city.name]) {
//                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:city.name];
//                        NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];
//                        if (titleResult.length>0) {
//                            [_searchResultArray addObject:city];
//                        }
//
//                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:city.name];
//                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
//
//                        if (titleHeadResult.length>1) {
//                            [_searchResultArray addObject:city];
//                        }
//                    } else {
//                        NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
//                        if (titleResult.length>0) {
//                            [_searchResultArray addObject:city];
//                        }
//                    }
//                }
//            }
//        } else {
//            for (int i=0; i<_cityArray.count; i++) {
//                NSArray *array = _cityArray[i];
//                for (ZZCity *city in array) {
//                    NSRange titleResult=[city.name rangeOfString:string options:NSCaseInsensitiveSearch];
//                    if (titleResult.length>0) {
//                        [_searchResultArray addObject:city];
//                    }
//                }
//            }
//        }
//    }
    
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
    
    ZZCityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZZCityNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XJCityModel *city = _searchResultArray[indexPath.row];
    cell.titleLabel.text = city.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.delegate respondsToSelector:@selector(selectCity:)]) {
        [self.delegate selectCity:_searchResultArray[indexPath.row]];
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
