//
//  QRCodeVC.m
//  DmoForTest
//
//  Created by Wikky on 15/11/12.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "QRCodeVC.h"
#import "CustomView.h"
#import "QRCodeGenerator.h"
#import "ScanQRCodeVCViewController.h"
@interface QRCodeVC ()
{
    UITextField *inputTF;
    UIView *viewview;
}
@property(nonatomic,strong)UIButton *btnTest;
@property(nonatomic,strong)UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;
@property (strong,nonatomic)UIImageView *qrcodeView;
@end

@implementation QRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"QRCode生成测试";
    [self initViews];
    // Do any additional setup after loading the view.
}

-(void)initViews
{
    CustomView *view1 = [[CustomView alloc]initWithFrame:[UIScreen mainScreen].bounds insertColorGradientTop:[UIColor yellowColor] buttomColor:[UIColor whiteColor]];
    [view1 insertColorGradientTop:[UIColor darkGrayColor] buttomColor:[UIColor whiteColor]];
    view1.alpha = 1;
    
    //    [self.view addSubview:view1];
    //扫描按钮
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnConfirm];
    btnConfirm.frame = CGRectMake(self.view.frame.size.width/2 - 100/2, 90,100 , 40);
    [btnConfirm setBackgroundColor:[UIColor lightGrayColor]];
    [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    btnConfirm.layer.cornerRadius = 6;
    btnConfirm.layer.masksToBounds = YES;
    [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.btnTest];
    self.btnTest.frame = CGRectMake(self.view.frame.size.width/2 - 100, 450, 200, 40);
    self.btnTest.layer.cornerRadius = 6;
    self.btnTest.layer.masksToBounds = YES;
    [self.btnTest setBackgroundColor:[UIColor lightGrayColor]];
    [self.btnTest setTitle:@"扫一扫" forState:UIControlStateNormal];
    [self.btnTest addTarget:self action:@selector(scanScan) forControlEvents:UIControlEventTouchUpInside];
    
    //输入框
    inputTF = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 300/2 , 30, 300, 40)];
    inputTF.borderStyle = UITextBorderStyleRoundedRect;
    inputTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputTF];
    [self initQRCode];
    
}
-(void)confirm
{
//    if (self.qrcodeView == nil) {
//        [self initQRCode];
//    }else
//    {
        [self.qrcodeView removeFromSuperview];
        [self initQRCode];
//    }
    [inputTF resignFirstResponder];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([inputTF becomeFirstResponder])
    {
        [inputTF resignFirstResponder];
    }
}
-(void)initQRCode
{
    
    self.qrcodeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 140, 150, 280, 280)];
    UIImage *qrcode = [[UIImage alloc]init];
    //下面是输入需要生成的字符串
    if ([inputTF.text isEqualToString:@""])
    {
        qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:@"phone = 13535554296 & babyid = 1231 & share_user_id = 123 & username = yeliangchen"] withSize:250.0f];
    }
    else
    {
        qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:inputTF.text] withSize:250.0f];
        
    }
    
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:36.0f andGreen:24.0f andBlue:36.0f];
    self.qrcodeView.image = customQrcode;
    // set shadow
    self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 2);
    self.qrcodeView.layer.shadowRadius = 2;
    self.qrcodeView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.qrcodeView.layer.shadowOpacity = 0.5;
    [self.view addSubview:self.qrcodeView];

//    viewview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
//    viewview.layer.cornerRadius = 6;
//    viewview.layer.masksToBounds = YES;
//    viewview.backgroundColor = [UIColor lightGrayColor];
//    viewview.center = self.qrcodeView.center;
//    [self.view addSubview:viewview];
}
//跳转到扫描页面
-(void)scanScan
{
    ScanQRCodeVCViewController *scan = [[ScanQRCodeVCViewController alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
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
