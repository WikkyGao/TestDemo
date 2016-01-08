//
//  ProtocalSecondVC.m
//  TestDemo
//
//  Created by Wikky on 15/12/18.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "ProtocalSecondVC.h"
@interface ProtocalSecondVC ()
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UITextField *testTF;
@end

@implementation ProtocalSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    // Do any additional setup after loading the view.
}
-(void)initViews
{
    self.testTF.placeholder = @"InputSomething";
    self.testTF.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testProtocal:(id)sender
{
    
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
