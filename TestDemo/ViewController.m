//
//  ViewController.m
//  TestDemo
//
//  Created by Wikky on 15/11/27.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "ViewController.h"
#import "FontAwesomeKitTestVC.h"
#import "AddressBookVC.h"
#import "UITestVC.h"
#import "AFNetworkingVC.h"
#import "QRCodeVC.h"
#import "UIStaffVC.h"
#import "MQTTKitTestVC.h"
#import "KindOfTestVC.h"
@interface ViewController ()<
UITableViewDataSource,
UITableViewDelegate>
{
    UIButton *btn;
    UITableView   *table;
    NSArray *titleArray;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"各种测试";
    self.view.backgroundColor = [UIColor whiteColor];
    titleArray = [NSArray arrayWithObjects:@"MQTTKit测试",@"AFNetworking测试",@"二维码测试",@"FontAwsomeKit测试",@"杂项测试",@"通讯录",@"UI测试", nil];
    [self initViews];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) initViews
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 667 - 64) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}
#pragma mark tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:identifier];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self goToMQTTKitTest];
            break;
        case 1:
            [self goToAFN];
            break;
        case 2:
            [self goToQRCodeTest];
            break;
        case 3:
            [self goToFontAwesomeKitTest];
            break;
        case 4:
            [self goToTest];
            break;
        case 5:
            [self addressPeople];
            break;
        case 6:
            [self goToUITest];
            break;
            
        default:
            NSLog(@"未开放");
            break;
    }
}
-(void)addressPeople
{
    AddressBookVC *addressBook = [[AddressBookVC alloc]init];
    
    [self.navigationController pushViewController:addressBook animated:YES];
    
}
-(void)goToQRCodeTest
{
    QRCodeVC *qrCode = [[QRCodeVC alloc]init];
    [self.navigationController pushViewController:qrCode animated:YES];
}
-(void)goToFontAwesomeKitTest
{
    FontAwesomeKitTestVC *fakV = [[FontAwesomeKitTestVC alloc]init];
    [self.navigationController pushViewController:fakV animated:YES];
}

-(void)goToTest
{
    KindOfTestVC *test = [[KindOfTestVC alloc]init];
    
    [self.navigationController pushViewController:test animated:YES];
}
-(void)goToMQTTKitTest
{
    MQTTKitTestVC *mqtt = [[MQTTKitTestVC alloc]init];
    [self.navigationController pushViewController:mqtt animated:YES];
    
}
-(void)goToAFN
{
    AFNetworkingVC *afn = [[AFNetworkingVC alloc]init];
    [self.navigationController pushViewController:afn animated:YES ];
    
}
-(void)goToUITest
{
    UIStaffVC *ui = [[UIStaffVC alloc]init];
    [self.navigationController pushViewController:ui animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
