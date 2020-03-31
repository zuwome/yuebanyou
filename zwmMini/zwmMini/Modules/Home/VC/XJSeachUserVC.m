//
//  XJSeachUserVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/22.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJSeachUserVC.h"
#import "XJSearchAccountView.h"
#import "XJSearchTableViewCell.h"
#import "XJLookoverOtherUserVC.h"
#import "XJPernalDataVC.h"

static NSString *searchTbViewCellIdentifier;

@interface XJSeachUserVC ()<XJSearchAccountViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) XJSearchAccountView *searchView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listArray;
@property(nonatomic,copy) NSString *searchStr;
@end

@implementation XJSeachUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索";
    self.searchStr = @"";
    [self showNavRightButton:@"搜索" action:@selector(doneSearchAction) image:nil imageOn:nil];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(7);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.view.backgroundColor = RGB(245, 245, 245);
    
    
}




- (void)doneSearchAction{
    
    NSLog(@"搜索");
    [AskManager GET:API_SEARCH_LIST_GET dict:@{@"nickname":self.searchStr}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        if (!rError) {
            
            NSLog(@"====%@",data);
            [self.listArray removeAllObjects];
            for (NSDictionary *dic in data) {
                
                XJUserModel *model = [XJUserModel yy_modelWithDictionary:dic];
                
                [self.listArray addObject:model];
            }
            
            [self.tableView reloadData];
            
        }else{
            
            
            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark searchViewDelegate
- (void)seachText:(NSString *)text{
    
//    NSLog(@"%@",text);
    self.searchStr = text;
    
}

#pragma mark tableViewDelegate and dataSoureDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchTbViewCellIdentifier];
    if (cell == nil) {
        cell = [[XJSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchTbViewCellIdentifier];
    }

    cell.model = self.listArray[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XJUserModel *uModel = self.listArray[indexPath.row];
    
    if ([XJUserAboutManageer.uModel.uid isEqualToString:uModel.uid]) {
        [self.navigationController pushViewController:[XJPernalDataVC new] animated:YES];
    }
    else{
        if (uModel.banStatus) {
            [MBManager showBriefAlert:@"该用户当前处于被封禁状态，无法进行此操作"];
            return;
        }
        XJLookoverOtherUserVC *lookvc = [XJLookoverOtherUserVC new];
        lookvc.topUserModel = uModel;
        [self.navigationController pushViewController:lookvc animated:YES];
        
    }
    
}


#pragma mark


- (XJSearchAccountView *)searchView{
    if (!_searchView) {
        
        _searchView = [[XJSearchAccountView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth, 50)];
        _searchView.delegate = self;
        
    }
    return _searchView;
    
    
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(245, 245, 245);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = defaultLineColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setTableFooterView:[UIView new]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
    }
    
    return _tableView;
    
}
- (NSMutableArray *)listArray{
    if (!_listArray) {
        
        _listArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _listArray;
    
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
