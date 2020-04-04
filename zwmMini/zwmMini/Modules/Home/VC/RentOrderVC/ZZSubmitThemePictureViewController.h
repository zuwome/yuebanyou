//
//  ZZSubmitThemePictureViewController.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "XJBaseVC.h"
#import "XJTopic.h"
/**
 *  上传主题图片
 */
#define PictureCollectionFooterHeight 90
#define PictureCollectionItemHeight ((kScreenWidth - 50) / 3)
@interface ZZSubmitThemePictureViewController : XJBaseVC

@property (nonatomic, strong) UICollectionView *picCollect;

@property (nonatomic, strong) void(^savePhotoCallback)(NSArray<XJPhoto> *photos);

@property (nonatomic, strong) NSMutableArray *pictureArray; //上传成功存储zzphoto，其余存储uiimage

@property (nonatomic, strong) XJTopic *topic;

- (BOOL)savePhotoManual;    //手动调用 返回图片数据回调

@end
