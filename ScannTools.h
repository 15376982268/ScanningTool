//
//  ScannTools.h
//  SGCQRCode
//
//  Created by liyanting on 17/1/13.
//  Copyright © 2017年 liyanting. All rights reserved.
//
/*
- - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系
- - GitHub下载地址 https://github.com/kingsic/SGQRCode.git -
 二维码扫描的步骤：
 1、创建设备会话对象，用来设置设备数据输入
 2、获取摄像头，并且将摄像头对象加入当前会话中
 3、实时获取摄像头原始数据显示在屏幕上
 4、扫描到二维码/条形码数据，通过协议方法回调
 
 AVCaptureSession 会话对象。此类作为硬件设备输入输出信息的桥梁，承担实时获取设备数据的责任
 AVCaptureDeviceInput 设备输入类。这个类用来表示输入数据的硬件设备，配置抽象设备的port
 AVCaptureMetadataOutput 输出类。这个支持二维码、条形码等图像数据的识别
 AVCaptureVideoPreviewLayer 图层类。用来快速呈现摄像头获取的原始数据
 二维码扫描功能的实现步骤是创建好会话对象，用来获取从硬件设备输入的数据，并实时显示在界面上。在扫描到相应图像数据的时候，通过AVCaptureVideoPreviewLayer类型进行返回
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ScannTools : NSObject

@property(nonatomic,copy) void (^scanInfoBlock)(NSString *);


-(instancetype)initWithShowView:(UIView *)showView;

#pragma mark 调用的界面消失的时候需要移除扫描的view
-(void)removeScanningView;



@end
