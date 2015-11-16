//
//  ScanViewController.m
//  MiTuan
//
//  Created by wangZL on 15/5/9.
//  Copyright (c) 2015年 qianfeng01. All rights reserved.
//

#import "ScanViewController.h"
//先声明一个系统声音ID,后面才能播放它
static SystemSoundID sound_id = 0;
@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    //判断当前设备是不是模拟器
    if (!TARGET_IPHONE_SIMULATOR)
    {
        [self scan];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备是模拟器，无法扫描二维码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
    }
}
- (void)scan
{
    //取到摄像头设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //初始化输入源
    _input = [AVCaptureDeviceInput  deviceInputWithDevice:_device error:nil];
    
    //初始化输出
    _output = [[AVCaptureMetadataOutput alloc]init];
    //设置扫描结果代理.在主线程中拿到扫描结果
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化会话
    _session = [[AVCaptureSession alloc]init];
    //设置会话为高清摄像头
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //将输入源,和输出源加入会话中
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    //设置扫描结果类型为二维码
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //初始化扫描框.
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    //设置扫描框,为缩放
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //设置扫描框坐标,大小
    _preview.frame = CGRectMake(50, 50, 200, 200);
    //将这个扫描框,加到self.view.layer上
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    //各种控件初始化完毕,开始扫描
    [_session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果,得到得时一个字符串
    NSString *stringValue = nil;
    
    //判断,结果数组是否有值
    if (metadataObjects.count >0)
    {
        //如果有值,取第一个元素
        AVMetadataMachineReadableCodeObject *object = metadataObjects[0];
        //拿到扫描结果字符串
        stringValue = object.stringValue;
    }
    //让会话结束
    [_session stopRunning];
    
    //播放"滴"声音
    //先取到文件路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"beep" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:path]), &sound_id);
    }
    
    //播放声音
    AudioServicesPlaySystemSound(sound_id);
    
    NSLog(@"扫描结果.stringValue==%@",stringValue);
}

@end