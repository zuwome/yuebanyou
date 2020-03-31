//
//  XJCoinRecordVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/4.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJCoinRecordVC.h"
#import "XJYoubiTbCell.h"
#import "XJSubYoubiRecordModel.h"
#import "XJYoubiRecordModel.h"

static NSString *tableIdentifier = @"coinTableviewidentifier";

@interface XJCoinRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *coinListArray;
@property(nonatomic,copy) NSString *sourvalue;

@end

@implementation XJCoinRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = defaultWhite;
    [self creatUI];
}

- (void)creatUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    
}

//下拉刷新
-(void)headerRereshing{
    
    NSLog(@"下拉刷新");
    self.sourvalue = @"";
    [self endfresh];
    [self.coinListArray removeAllObjects];
    [self getCoinData];
    
}

//上拉加载
-(void)footerRereshing{
    
    [self endfresh];
    if (self.coinListArray.count >0) {
        XJYoubiRecordModel *lmodel = [self.coinListArray lastObject];
        self.sourvalue = lmodel.sort_value;
        [self getCoinData];
    }
    
    NSLog(@"上拉加载");
    
}



- (void)getCoinData{
    
    [AskManager GET:API_M_COIN_RECORD_GET dict:@{@"sort_value":self.sourvalue}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        
        [self endfresh];

        if (!rError) {
            
            

            NSLog(@"%@",data);
            
            for (NSDictionary *dic in data) {
                
                XJYoubiRecordModel *lmodel = [XJYoubiRecordModel yy_modelWithDictionary:dic];
                
                [self.coinListArray addObject:lmodel.mcoin_record];
            }
            
            if ([data count] == 0) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            
            [self.tableView reloadData];
            
        }else{
            
            
        }
        
    } failure:^(NSError *error) {
        [self endfresh];
    }];
    
}

- (void)endfresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}




#pragma mark tableviewDelegate and dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 87.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return self.coinListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJYoubiTbCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if (cell == nil) {
        cell = [[XJYoubiTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    if (self.coinListArray.count > 0) {
        [cell setUpContent:self.coinListArray[indexPath.row]];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


#pragma mark lazy

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight - 64-SafeAreaBottomHeight-SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = NO;
        _tableView.mj_header = header;
        
        //底部刷新
        MJRefreshBackNormalFooter *footer =  [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [footer setTitle:@"我是有底线的～" forState: MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:14.f];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _tableView.mj_footer = footer;
        
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.scrollIndicatorInsets = _tableView.contentInset;
        }else{
            //            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _tableView;
}

- (NSMutableArray *)coinListArray{
    if (!_coinListArray) {
        _coinListArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _coinListArray;
    
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
