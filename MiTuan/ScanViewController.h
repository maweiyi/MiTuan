//
//  ScanViewController.h
//  MiTuan
//
//  Created by wangZL on 15/5/9.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import <UIKit/UIKit.h>
//摄像头需要使用视频服务
#import <AVFoundation/AVFoundation.h>
//遵守扫描结果的协议
@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)AVCaptureDevice *device;//扫描设备
@property (nonatomic,strong)AVCaptureDeviceInput *input;//输入源
@property (nonatomic,strong)AVCaptureMetadataOutput *output;//输出
@property (nonatomic,strong)AVCaptureSession *session;//扫描会话
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;//扫描窗口

@end