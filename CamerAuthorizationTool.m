//
//  CamerAuthorizationTool.m
//  SGCQRCode
//
//  Created by uxin on 17/1/13.
//  Copyright © 2017年 liyanting. All rights reserved.
//

#import "CamerAuthorizationTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation CamerAuthorizationTool

// 相机使用访问
-(void)getCameraAuthorizaionBlockWithReturnBlock:(AuthorizaReturnBlock) returnBlock
    WithErrorBlock: (AuthorizaErrorCodeBlock) errorBlock{


    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
       
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
        {
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
            
            if (errorBlock) {
                
                errorBlock([NSString stringWithFormat:@"请去 [设置 - %@ - 相机 ] 打开访问开关",app_Name]);
            }
        
        }else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
            
            if (returnBlock) {
                
                returnBlock();
            }
            
        } else if (status == AVAuthorizationStatusNotDetermined) { // 用户还没有做出选择
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    if (returnBlock) {
                        
                        returnBlock();
                    }
                }else{
                

                }
            }];
            
        }
        

        
        
    } else {
        
        if (errorBlock) {
            
            errorBlock(@"未检测到您的摄像头, 请在真机上使用");
        }
        
        
    }


}
//相册使用访问
- (void)getPhotoAuthorizaionBlockWithReturnBlock: (AuthorizaReturnBlock) returnBlock
                              WithErrorBlock: (AuthorizaErrorCodeBlock) errorBlock{

    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        
        if (errorBlock) {
            
            errorBlock(@"无法访问相册");
        }
        
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        if (errorBlock) {
            
            errorBlock([NSString stringWithFormat:@"请去 [设置 - %@ - 照片 ] 打开访问开关",app_Name]);
        }
        
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
        
        if (returnBlock) {
            
            returnBlock();
        }
        
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                
                if (returnBlock) {
                    
                    returnBlock();
                }
            }
        }];
    }


}

@end
