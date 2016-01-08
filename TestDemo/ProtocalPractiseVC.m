//
//  ProtocalPractiseVC.m
//  TestDemo
//
//  Created by Wikky on 15/12/18.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "ProtocalPractiseVC.h"

@interface ProtocalPractiseVC ()

@end

@implementation ProtocalPractiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initViews];
    // Do any additional setup after loading the view.
}
-(void)initViews
{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 120, 50)];
    lab.backgroundColor = [UIColor redColor];
    lab.textColor  = [UIColor whiteColor];
    lab.text = @"memeda";
    [self.view addSubview:lab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 160, 80, 50);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self  action:@selector(goToSecond) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
-(void)goToSecond
{
    ProtocalSecondVC *second = [[ProtocalSecondVC alloc]init];
    [self.navigationController pushViewController:second  animated:YES];
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
