//
//  XJSelectJobsVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/28.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSelectJobsVC.h"
#import "XJSelectJobsTbCell.h"
#import "XJSelectJbosCollectionViewCell.h"

static NSString *tableIdentifier = @"editjobsTableviewidentifier";
static NSString *collectionIdentifier = @"editjobsCollectionidentifier";

@interface XJSelectJobsVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) NSMutableArray *jobClassArray;
@property(nonatomic,strong) NSMutableArray *subJobArray;
@property(nonatomic,strong) NSMutableArray *isSelectJobArray;

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSIndexPath *lastIndexPath;

@property(nonatomic,copy) NSArray<NSString *> *selectedArray;

@end


@implementation XJSelectJobsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择职业";
    self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    XJUserModel *model = XJUserAboutManageer.uModel;
    NSMutableArray *array = @[].mutableCopy;
    [model.works_new enumerateObjectsUsingBlock:^(XJInterstsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.content];
    }];
    _selectedArray = array.copy;
    
    [self showNavRightButton:@"" action:@selector(doneAction) image:GetImage(@"dagou") imageOn:GetImage(@"dagou")];
    [self creatUI];
    [self getJobsList];
    
    
    
}


- (void)doneAction{
    if (self.isSelectJobArray.count > 0) {
        NSMutableDictionary *pushDic = @{@"works_new":self.isSelectJobArray}.mutableCopy;
        [AskManager POST:API_UPDATA_JOBS dict:pushDic succeed:^(id data, XJRequestError *rError) {
            
            if (!rError) {
                
                //            NSLog(@"===%@",data);
                XJUserAboutManageer.uModel = [XJUserModel yy_modelWithDictionary:data];
                [MBManager showBriefAlert:@"更新职业成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatejobs" object:self];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        

            
        } failure:^(NSError *error) {
            
            
        }];

    }else{
        [MBManager showBriefAlert:@"请选择职业"];
        
    }
    
    
}

- (void)creatUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(78);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.view);
        make.left.equalTo(self.tableView.mas_right);
    }];
}

- (void)getJobsList{
    __weak typeof(self) weakSelf = self;
    [MBManager showLoading];
    [AskManager GET:API_GET_JOBS_LIST dict:@{}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
      
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.jobClassArray addObject:obj[@"job_cate"]];
                [self.subJobArray addObject:obj[@"sub_jobs"]];
                [obj[@"sub_jobs"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([weakSelf.selectedArray containsObject:obj[@"content"]]) {
                        [weakSelf.isSelectJobArray addObject:obj];
                    }
                }];
            }];
           
            
            [self.tableView reloadData];
            [self.collectionView reloadData];
                  NSLog(@"%@",data);
            
        }
        
        [MBManager hideAlert];
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];

        
    }];
    
}

#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.jobClassArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XJSelectJobsTbCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[XJSelectJobsTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    [cell setUpJobsTitle:self.jobClassArray[indexPath.row][@"content"] andIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titileLb.backgroundColor = defaultWhite;
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.lastIndexPath) {
        XJSelectJobsTbCell *cell = (XJSelectJobsTbCell *)[tableView cellForRowAtIndexPath:self.lastIndexPath];
        cell.titileLb.backgroundColor = RGB(255, 233, 237);
    }
    
    XJSelectJobsTbCell *cell = (XJSelectJobsTbCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.titileLb.backgroundColor = defaultWhite;
    NSLog(@"%@",self.jobClassArray[indexPath.row]);
     self.lastIndexPath = indexPath;
    [self.collectionView reloadData];
    
}



#pragma mark collectionViewDelegate dataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth-78-26-32)/3.f, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(14, 16, 14, 16);//（上、左、下、右）
}
#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.f;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.f;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.subJobArray.count == 0) {
        return 0;
    }
    return [self.subJobArray[self.lastIndexPath.row] count];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XJSelectJbosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[XJSelectJbosCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    
    NSDictionary *currentDic = self.subJobArray[self.lastIndexPath.row][indexPath.item];
    NSString *index = [NSString stringWithFormat:@"%ld",(long)self.lastIndexPath.row];

    BOOL isselect = NO;
    if ([self.isSelectJobArray containsObject:currentDic]) {
        isselect = YES;
    }
    [cell setUpSubJobsDic:currentDic andIndexPath:indexPath isSelect:isselect];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
   
    XJSelectJbosCollectionViewCell *cell = (XJSelectJbosCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *currentDic = self.subJobArray[self.lastIndexPath.row][indexPath.item];
    
    if ([self.isSelectJobArray containsObject:currentDic]) {
        cell.titileLb.layer.borderColor = RGB(122, 122, 122).CGColor;
        cell.titileLb.backgroundColor = defaultWhite;
        cell.titileLb.textColor = RGB(122, 122, 123);
        
        [self.isSelectJobArray removeObject:currentDic];
    }
    else {
        if (self.isSelectJobArray.count == 10) {
            [MBManager showBriefAlert:@"最多选择10个标签"];
            return;
        }
        
        cell.titileLb.layer.borderColor = RGB(254, 83, 108).CGColor;
        cell.titileLb.backgroundColor = RGB(254, 83, 108);
        cell.titileLb.textColor = UIColor.whiteColor;
        
        [self.isSelectJobArray addObject:currentDic];
    }
}

#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(255, 233, 237);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = defaultWhite;
        [_collectionView registerClass:[XJSelectJbosCollectionViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
        
    }
    return _collectionView;
}
- (NSMutableArray *)jobClassArray{
    
    if (!_jobClassArray) {
        _jobClassArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _jobClassArray;
    
}
- (NSMutableArray *)subJobArray{
    
    if (!_subJobArray) {
        _subJobArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _subJobArray;
    
}
- (NSMutableArray *)isSelectJobArray{
    
    if (!_isSelectJobArray) {
        _isSelectJobArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _isSelectJobArray;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
