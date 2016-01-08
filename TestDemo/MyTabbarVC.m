//
//  MyTabbarVC.m
//  TestDemo
//
//  Created by Wikky on 15/12/31.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "MyTabbarVC.h"
#import "ViewController.h"
@interface MyTabbarVC ()
@property(nonatomic,strong)UIButton *selectBtn;
@end

@implementation MyTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    NSLog(@"%@",self.view.subviews);
    [self initControllers];
    // Do any additional setup after loading the view.
}
-(void)initControllers
{
    CGRect rect = self.tabBar.frame;
    [self.tabBar removeFromSuperview];
    UIView *myView = [[UIView alloc]init];
    myView.frame = rect;
    myView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:myView];
    self.selectBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setBackgroundColor:[UIColor yellowColor]];
    
    for (int i = 0; i < 4; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setBackgroundColor:[UIColor lightGrayColor]];
        
        
        
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"botton-icon0%d",i+1]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"botton-icon0%ds",i+1]] forState:UIControlStateNormal];
        CGFloat x= i * myView.frame.size.width/4;
        btn.frame = CGRectMake(x, 0, myView.frame.size.width / 5, myView.frame.size.height);
        [myView addSubview:btn];
        btn.tag = i;
        [btn addTarget: self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            self.selectBtn = btn;
        }
    }
}

-(void)clickBtn:(UIButton*)button
{
    self.selectBtn.selected = NO;
    button.selected = YES;
    self.selectBtn = button;
    self.selectedIndex = button.tag;
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
