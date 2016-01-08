//
//  AFNetworkingVC.m
//  Pods
//
//  Created by Wikky on 15/10/27.
//
//

#import "AFNetworkingVC.h"
#import "AFNetworking.h"
#import "NSString+Hash.h"
#import "UIImageView+WebCache.h"
//#import <AFURLRequestSerialization.h>
@interface AFNetworkingVC ()
{
    UIImageView *imv;
}
@end

@implementation AFNetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"AFNetWorking测试";
//    [self test];
    [self initViews];
//    [self imgDownloadRequest];
    
    [self imgUploadRequest];
}
-(void)imgUploadRequest
{
    NSString *strHost = @"http://api.bbcheck.net:8800/index";
    NSString *strPort = @"/baby_list";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",strHost,strPort];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:
                            @{
                              @"userid":@"4",
                              }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"Json==>>>%@ \n Done",dict);
        
        if([[dict valueForKey:@"status"]isEqualToString:@"success"])
        {
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
    }];
    
//    NSData *data = [NSData dataWithContentsOfFile:@""];

}
-(void)initViews
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(AFNetworkingUrlRequestWithImgData)];
    self.navigationItem.rightBarButtonItem = right;
    UIImage *img = [UIImage imageNamed:@"suer.PNG"];
    imv = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 638/8, 80, 638/4, 854/4)];
    imv.backgroundColor = [UIColor lightGrayColor];
//    [imv sd_setImageWithURL:[NSURL URLWithString:@"http://api.bbcheck.net:8800/uploads/2015-12-07/2b0c696bad404e072dc502aaff6295901449453550.jpg"] placeholderImage:img];
    
    [imv sd_setImageWithURL:[NSURL URLWithString:@"http://api.bbcheck.net:8800/uploads/2015-12-07/2b0c696bad404e072dc502aaff6295901449453550.jpg"] placeholderImage:img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"sd_setImageWithURL initViews");
        [self.view reloadInputViews];
    }];
    UIImageView *imv2 = [[UIImageView alloc]initWithImage:img];
    imv2.frame = CGRectMake(self.view.center.x - 638/8 , self.view.center.y + 40, 638/4,854/4);
    imv2.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:imv];
    [self.view addSubview:imv2];
}
//AFNETWORKING
//-(void)imgDownloadRequest
//{
//    NSString *urlStr =@"http://119.134.250.31/index/baby_list";
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //很重要，去掉就容易遇到错误，暂时还未了解更加详细的原因
//    [manager POST:urlStr parameters:
//     @{
//       @"userid":@"4",
//       }
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////              NSString *string = [dict objectForKey:@"babylist"];
//              NSString *str =@"";
//              NSArray *arr = [NSArray arrayWithArray:[dict objectForKey:@"babylist"]];
//              for (NSDictionary *dicttt in arr) {
//                  if ([[dicttt valueForKey:@"babyid"]isEqualToString:@"F99D0651-6B6E-4FDC-9DE6-6D596175988E"]) {
//                      NSLog(@"%@",[dicttt valueForKey:@"avatarId"]);
//                      str = [dicttt valueForKey:@"avatarId"];
//                  }
//              }
////              NSURLRequest *request = [NSURLRequest requestWithURL:str];
////              [imv setImage:[NSURL URLWithString:str]];
//              [imv sd_setImageWithURL:[NSURL URLWithString:str]placeholderImage: [UIImage imageNamed:@"placeholder-avatar"]];
//
////              NSURLRequest *request = [NSURLRequest requestWithURL:[]
////              NSLog(@"JSON: %@", string);
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"error:%@",error.localizedDescription);
//          }];
//}
-(void)AFNetworkingUrlRequestWithImgData
{
    UIImage *img = [UIImage imageNamed:@"suer.PNG"];
    NSData *imgData = UIImageJPEGRepresentation(img, 1);

    NSString *urlStr =@"http://119.134.250.31/index/baby_update";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [[NSUUID UUID]UUIDString];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:
     @{
       @"userid":@"4",
       @"name":@"已修改的bbb",
       @"gender":@"1",
       @"avatarId":[NSString stringWithFormat:@"/uploads/%@/%@",strDate,imgData],
       @"img_update":@"1",
       @"babyid":@"F99D0651-6B6E-4FDC-9DE6-6D596175988E"
       }
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imgData name:@"uploads" fileName:fileName mimeType:@"image/jpg"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *string = [dict objectForKey:@"status"];
        NSLog(@"JSON: %@", string);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"JSON:%@",error.localizedDescription);

    }];
}

//737D4676-64A3-4FF0-ACC1-944284DCB3A2
-(void)AFNurlRequest
{
    NSString *urlStr =@"http://119.134.250.31/index/baby_update";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:
     @{
       @"userid":@"4",
       @"name":@"已修改的bb",
       @"gender":@"0",
       @"avatar":@"upLoad",
       @"img_update":@"1",
       @"babyid":@"F99D0651-6B6E-4FDC-9DE6-6D596175988E"
       }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//              formatter.dateFormat = @"yyyy-MM-dd";
//              NSString *str = [formatter stringFromDate:[NSDate date]];
//              NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
              NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSString *string = [dict objectForKey:@"status"];
              NSLog(@"JSON: %@", string);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error:%@",error.localizedDescription);
          }];
    
}

-(void)test
{
    
    
}
-(void)add_babyRequest
{

    NSURL *url = [NSURL URLWithString:@"http://119.134.250.31/index/add_baby"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"POST";
    NSString *bodyStr =@"userid = 4 & babyid = 1231 & share_user_id = 5";
    NSData *data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //block里面的三个参数 服务器响应信息 下载的data 错误信息
        NSString *resultStr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resultStr);
        //解析data
        NSDictionary *dict = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSLog( @"====>%@",[dict valueForKey:@"status"]);
    }];
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"message"]==nil){

        [[NSUserDefaults standardUserDefaults] setObject:@"This_is_my_default_message" forKey:@"message"];
    }
    
    NSLog(@"Defaults: %@", [defaults valueForKey:@"message"]);
    
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
