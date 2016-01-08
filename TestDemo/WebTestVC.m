//
//  WebTestVC.m
//  TestDemo
//
//  Created by Wikky on 15/12/29.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "WebTestVC.h"

@interface WebTestVC ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation WebTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)initViews
{
    webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.163.com"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
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
