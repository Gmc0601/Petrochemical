//
//  LeasCustomAlbum.m
//  BaseProject
//
//  Created by 桃子leas on 2018/3/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "LeasCustomAlbum.h"
#import "FactorySet.h"

static LeasCustomAlbum *model = nil;

@interface LeasCustomAlbum()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (copy, nonatomic)  ReturnImage  value;
@end

@implementation LeasCustomAlbum

+ (instancetype ) sharedModel{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[LeasCustomAlbum allocWithZone:NULL]init];
    });
    return model;
}

+ (void) getImageWith:(UIViewController *) controller Value:(ReturnImage) images{
    
    [LeasCustomAlbum sharedModel].value = images;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择头像来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
            //                    imgPickerVC.restorationIdentifier=kheadTag;
            [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPickerVC setDelegate:[LeasCustomAlbum sharedModel]];
            //听说这玩意能减少内存报警
            imgPickerVC.videoQuality=UIImagePickerControllerQualityTypeLow;
            [imgPickerVC setAllowsEditing:YES];
            //显示Image Picker
            
            [controller presentViewController:imgPickerVC animated:YES completion:nil];
            
        }else {
            
        }
    }];
    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
            //                    cameraVC.restorationIdentifier=kheadTag;
            [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [cameraVC setDelegate:[LeasCustomAlbum sharedModel]];
            //听说这玩意能减少内存报警
            cameraVC.videoQuality=UIImagePickerControllerQualityTypeLow;
            [cameraVC setAllowsEditing:YES];
            //显示Camera VC
            [controller presentViewController:cameraVC animated:YES completion:nil];
            
        }else {
            
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancelAction setValue:UIColorFromHex(0x666666) forKey:@"_titleTextColor"];
    [okAction1 setValue:UIColorFromHex(0x333333) forKey:@"_titleTextColor"];
    [okAction2 setValue:UIColorFromHex(0x333333) forKey:@"_titleTextColor"];
    [alertVC addAction:okAction1];
    [alertVC addAction:okAction2];
    [alertVC addAction:cancelAction];
    [controller presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate,UINavigationControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //这里只是更换头像
    UIImage *newImage = info[UIImagePickerControllerOriginalImage];
    _value(newImage);
    [picker dismissViewControllerAnimated:YES completion:nil];

}

@end
