//
//  RadioBtnVC.m
//  TestDemo
//
//  Created by Wikky on 15/12/15.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "RadioBtnVC.h"
#import "QRadioButton.h"
@interface RadioBtnVC ()<
QRadioButtonDelegate
>

@end

@implementation RadioBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
    // Do any additional setup after loading the view.
    
}
-(void)initViews
{

    QRadioButton *radio1 =[[QRadioButton alloc]initWithDelegate:self groupId:@"ID1"];
    radio1.frame = CGRectMake(20,80, 80, 50) ;
    [radio1 setTitle:@"男" forState:UIControlStateNormal];
    [radio1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:radio1];
    [radio1 setChecked:YES];
    
    QRadioButton *radio2 =[[QRadioButton alloc]initWithDelegate:self groupId:@"ID1"];
    radio2.frame = CGRectMake(120,80, 80, 50) ;
    [radio2 setTitle:@"女" forState:UIControlStateNormal];
    [radio2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [self.view addSubview:radio2];
    [radio2 setChecked:NO];
}
#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSLog(@"Did Selected RadioBtn:%@ groupId:%@", radio.titleLabel.text, groupId);
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
