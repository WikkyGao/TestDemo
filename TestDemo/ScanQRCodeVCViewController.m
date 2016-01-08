//
//  ScanQRCodeVCViewController.m
//  DmoForTest
//
//  Created by Wikky on 15/11/5.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "ScanQRCodeVCViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "NSString+Hash.h"
#import "BlueHeader.h"
@interface ScanQRCodeVCViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    NSString *str;
}
@property(nonatomic,strong)UIButton *btnTest;
@property(nonatomic,strong)UIView *viewPreview;
@property(nonatomic,strong)UITextView *lalStatus;
@property(nonatomic,strong)UIButton *startBtn;
@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;



@end

@implementation ScanQRCodeVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"QRCode扫描测试";
    _captureSession = nil;
    _isReading = NO;
    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
//    self.viewPreview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.viewPreview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.viewPreview];
    self.viewPreview .backgroundColor = [UIColor yellowColor];
    
    self.lalStatus = [[UITextView alloc]initWithFrame:CGRectMake(0, 10, 375, 40)];
    self.lalStatus.editable = NO;
    self.lalStatus.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.lalStatus];
    
    self.btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.btnTest];
    self.btnTest.frame = CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height - 60 - 64, 200, 40);
    [self.btnTest setBackgroundColor:[UIColor lightGrayColor]];
    [self.btnTest setTitle:@"扫扫扫" forState:UIControlStateNormal];
    [self.btnTest addTarget:self action:@selector(startStopReading) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self startReading];
    
    
    
//    if (!_isReading) {
//        if ([self startReading]) {
//            [_startBtn setTitle:@"Stop" forState:UIControlStateNormal];
//            [_lalStatus setText:@"Scanning for QR Code"];
//        }
//    }
//    else{
//        [self stopReading];
//        [_startBtn setTitle:@"Start!" forState:UIControlStateNormal];
//    }
//    
//    _isReading = !_isReading;
    
}


-(void )startStopReading
{
    if (!_isReading) {
        if ([self startReading]) {
            [_btnTest setTitle:@"扫描ing....." forState:UIControlStateNormal];
            [_lalStatus setText:@"Scanning for QR Code"];
        }
    }
    else{
        [self stopReading];
    }
}




- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //10.1.扫描框
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
    _boxView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    
    [_viewPreview addSubview:_boxView];
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 2);
    _scanLayer.backgroundColor = [UIColor redColor].CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    
    
    return YES;
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_lalStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            str =[metadataObj stringValue];
            [self reques:str];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
    [self.boxView removeFromSuperview];
    [_btnTest setTitle:@"再扫一次" forState:UIControlStateNormal];
    
}

-(void)loginRequest
{
    NSString *pwd = @"123qwe";
    NSString *pwdMD5 = [pwd md5String];//MD5加密
    NSString *strHost = Host;
    NSString *strPort = @"/login_check";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",strHost,strPort];
//    NSString *str11 = @"http://119.134.250.31/index/login_check";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    request.HTTPMethod = @"POST";
    NSString *bodyStr =[NSString stringWithFormat:@"phone=13535554296&pwd=%@",pwdMD5];
    NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //block里面的三个参数 服务器响应信息 下载的data 错误信息
        //解析data
        if (data) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog( @"%@",[dict valueForKey:@"status"]);
            if ([[dict valueForKey:@"status"] isEqualToString:@"success"])//登录成功
            {
                NSLog(@"登录成功");
            }
            else if([[dict valueForKey:@"status"] isEqualToString:@"error_username_or_password_error"])
            {
                NSLog(@"登录失败");
            }
            
        }
        else
        {
            NSLog(@"%@",connectionError);

        }
    }];
    
    
}

-(void)reques:(NSString *)str1
{
    
    NSString *strHost = Host;
    NSString *strPort = @"/share";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",strHost,strPort];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"POST";
    NSString *bodyStr =str1;
    NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //block里面的三个参数 服务器响应信息 下载的data 错误信息
        NSString *resultStr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resultStr);
        //解析data
        NSDictionary *dict = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog( @"====%@",[dict valueForKey:@"status"]);
    }];
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
