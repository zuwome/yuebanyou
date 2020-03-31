//
//  XJRealNameAutoVC.m
//  zwmMini
//
//  Created by Batata on 2018/11/26.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJRealNameAutoVC.h"
#import "XJRealNameVCTbCell.h"
#import "XJThridRealNameVCTbCell.h"
#import "XJIDCardVC.h"
#import "XJIDCardFailVC.h"

static NSString *myTableviewIdentifier = @"mysrealnametableviewIdentifier";

@interface XJRealNameAutoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation XJRealNameAutoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self creatUI];
}


- (void)creatUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
   
}

#pragma mark tableviewDelegate and dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 65.f;
    }
    return 117.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    NSInteger line =  XJUserAboutManageer.uModel.realname.status == 2 ? 1:2;
    
    return line;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 1 && XJUserAboutManageer.uModel.realname.status != 2) {
        
        XJThridRealNameVCTbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[XJThridRealNameVCTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
        
    }
    XJRealNameVCTbCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableviewIdentifier];
    if (cell == nil) {
        cell = [[XJRealNameVCTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableviewIdentifier];
    }
    NSInteger type = indexPath.row == 0 ? XJUserAboutManageer.uModel.realname.status : XJUserAboutManageer.uModel.realname_abroad.status;
    [cell setUpContentisReal:type withIndexpath:indexPath];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {

            XJIDCardVC *idvc = [XJIDCardVC new];
            idvc.type =  XJUserAboutManageer.uModel.realname.status;
            [self.navigationController pushViewController:idvc animated:YES];
            
            
        }
            break;
        case 1:
        {
            
            XJIDCardFailVC *failVC = [XJIDCardFailVC new];
            [self.navigationController pushViewController:failVC animated:YES];

        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
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
        _tableView.backgroundColor = defaultLineColor;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
