//
//  XJReportVC.m
//  zwmMini
//
//  Created by Batata on 2018/12/20.
//  Copyright © 2018 zuwome. All rights reserved.
//

#import "XJReportVC.h"
#import "XJReportTextTbCell.h"
#import "XJReportOhterTbCell.h"
#import "XJReportImgsTbCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "PECropViewController.h"

@interface XJReportVC ()<UITableViewDelegate,UITableViewDataSource,XJReportImgsTbCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSArray *titlesArray;
@property(nonatomic,strong) NSIndexPath *lastIndexpath;
@property(nonatomic,copy) NSString *selectStr;
@property(nonatomic,copy) NSString *otherStr;
@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,assign) CGFloat otherheght;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong) UIButton *addivBtn;




@end

@implementation XJReportVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
    
    [self showNavRightButton:@"提交" action:@selector(pushAction) image:nil imageOn:nil];
    self.lastIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.selectStr = @"";
    self.otherStr = @"";
    self.otherheght = 0.01;
    [self creatUI];
    
}

- (void)creatUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addImage:(UIButton *)btn{
    self.addivBtn = btn;
    [self showImagePickerController];
    
}
- (void)pushAction{
    
    if (NULLString(self.selectStr)) {
        [MBManager showBriefAlert:@"请选择举报原因"];
        return;
    }
    if (NULLString(self.imgUrl)) {
        [MBManager showBriefAlert:@"请上传一张图片作为凭证"];
        return;
    }
    if ([self.selectStr isEqualToString:@"其他"]) {
        
        if (NULLString(self.otherStr)) {
            [MBManager showBriefAlert:@"请输入其他原因"];
            return;
        }
    }
    NSString *content = NULLString(self.otherStr)? self.selectStr:self.otherStr;
    [MBManager showWaitingWithTitle:@"举报中..."];
    [AskManager POST:API_REPORT_USER_(self.uid) dict:@{@"content":content,@"photos":@[self.imgUrl]}.mutableCopy succeed:^(id data, XJRequestError *rError) {
        
        if (!rError) {
            [MBManager showBriefAlert:@"举报成功"];
            [self.navigationController popViewControllerAnimated:YES];

        }
        [MBManager hideAlert];
    } failure:^(NSError *error) {
        
        [MBManager hideAlert];

    }];
    
    
    
    
    
}
#pragma mark ShowImagePickerController
- (void)showImagePickerController
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @WeakObj(self);
    UIAlertAction *takePhotoAct = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        //选择相机时，设置UIImagePickerController对象相关属性
        self.imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //跳转到UIImagePickerController控制器弹出相机
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *photoAct = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        //选择相册时，设置UIImagePickerController对象相关属性
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //跳转到UIImagePickerController控制器弹出相册
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:takePhotoAct];
    [alert addAction:photoAct];
    [alert addAction:cancelAct];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    UIImage * image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self uploadImg:image];
    
    
}
- (void)uploadImg:(UIImage *)image{
    
    //上传头像
    [MBManager showWaitingWithTitle:@"上传图片中..."];
    [XJUploader uploadImage:image progress:^(NSString *key, float percent) {
        
    } success:^(NSString * _Nonnull url) {
        
        [MBManager hideAlert];
        self.imgUrl = url;
        [self.addivBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.addivBtn setImage:[UIImage new] forState:UIControlStateNormal];
        
    } failure:^{
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"上传失败"];
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableviewDelegate and dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.titlesArray.count) {
        return self.otherheght;
//        return 190.f;

    }else if (indexPath.row == self.titlesArray.count + 1) {
        return 190.f;
    }else{
        return 50.f;

    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titlesArray.count+2;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.titlesArray.count+1) {
        
        XJReportImgsTbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagescell"];
        if (cell == nil) {
            cell = [[XJReportImgsTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imagescell"];
        }
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == self.titlesArray.count) {
        
        XJReportOhterTbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"othercell"];
        
        if (cell == nil) {
            cell = [[XJReportOhterTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"othercell"];
        }
        cell.block = ^(NSString * _Nonnull otherStr) {
            self.otherStr = otherStr;
        };
        return cell;
    }
    
    XJReportTextTbCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentcell"];
    
    if (cell == nil) {
        cell = [[XJReportTextTbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentcell"];
    }
    [cell setUpContent:self.titlesArray[indexPath.row] isSelect:NO];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    if (indexPath.row<self.titlesArray.count) {
        
        self.otherStr = @"";
        XJReportTextTbCell *lastcell = [tableView cellForRowAtIndexPath:self.lastIndexpath];
        XJReportTextTbCell *currentcell = [tableView cellForRowAtIndexPath:indexPath];
        if ([self.selectStr isEqualToString:self.titlesArray[indexPath.row]]) {
            [currentcell setUpContent:self.selectStr isSelect:NO];
        }else{
            [lastcell setUpContent:self.titlesArray[self.lastIndexpath.row] isSelect:NO];
            [currentcell setUpContent:self.titlesArray[indexPath.row] isSelect:YES];
            self.selectStr = self.titlesArray[indexPath.row] ;
        }
        self.lastIndexpath = indexPath;
        NSLog(@"%@",self.selectStr);
        if (indexPath.row == self.titlesArray.count - 1) {
            self.otherheght = 190.f;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.titlesArray.count inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            self.otherheght = 0.01;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.titlesArray.count inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
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

- (NSArray *)titlesArray{
    
    if (!_titlesArray) {
        
        _titlesArray = @[@"淫秽色情",@"恶意骚扰、不文明语言",@"涉嫌广告、传销等内容",@"欺诈（酒托、饭托等）",@"本人与资料不符",@"涉嫌政治及暴力内容",@"其他"];
    }
    return _titlesArray;
}
- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        //创建UIImagePickerController对象，并设置代理和可编辑
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.editing = YES;
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
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
