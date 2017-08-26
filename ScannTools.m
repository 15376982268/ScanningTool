//
//  ScannTools.m
//  SGCQRCode
//
//  Created by uxin on 17/1/13.
//  Copyright © 2017年 liyanting. All rights reserved.
//

#import "ScannTools.h"
#import <AVFoundation/AVFoundation.h>
#import "SGScanningQRCodeView.h"

@interface ScannTools()<AVCaptureMetadataOutputObjectsDelegate>

/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property(nonatomic, strong) UIView * showView;

@property (nonatomic, strong) SGScanningQRCodeView *scanningView;//扫描边框

/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;

@end
@implementation ScannTools
-(instancetype)initWithShowView:(UIView *)showView{
    
    
    self = [super init];
    if (self) {
        
        self.showView = showView;
        
        // 创建扫描边框
        self.scanningView = [[SGScanningQRCodeView alloc] initWithFrame:self.showView.frame outsideViewLayer:self.showView.layer];
        [self.showView addSubview:self.scanningView];
        
        // 二维码扫描
        [self setupScanningQRCode];
        
        
    }
    
    return self;
    
}
#pragma mark - - - 二维码扫描
- (void)setupScanningQRCode {
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 5、初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 5.1 添加会话输入
    [_session addInput:input];
    
    // 5.2 添加会话输出
    [_session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.showView.layer.bounds;
    
    // 8、将图层插入当前视图
    [self.showView.layer insertSublayer:_previewLayer atIndex:0];
    
    // 9、启动会话
    [_session startRunning];
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 会频繁的扫描，调用代理方法
    
    
    // 1、如果扫描完成，停止会话
    [self.session stopRunning];
    
    // 2、删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    // 3、设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (self.scanInfoBlock) {
            
            self.scanInfoBlock(obj.stringValue);
            
        }
      
//        NSLog(@"metadataObjects = %@", metadataObjects);
//        
//        if ([obj.stringValue hasPrefix:@"http"]) {
//            
//            
//            
//        } else { // 扫描结果为条形码
//            
//            
//        }
    }
}

#pragma mark 调用的界面消失的时候需要移除扫描的view
-(void)removeScanningView{
    
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
    
    
}

-(void)dealloc{


    DebugLog(@"Tool释放啦");
    
}


@end
