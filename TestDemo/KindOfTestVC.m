//
//  KindOfTestVC.m
//  DmoForTest
//
//  Created by Wikky on 15/11/12.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "KindOfTestVC.h"
#import "Reachability.h"
#import "BlueHeader.h"
#import "ProtocalPractiseVC.h"
@interface KindOfTestVC ()<
UITableViewDataSource,
UITableViewDelegate>
{
    UITableView *table;
    NSMutableArray *titleArray;
}
@end

@implementation KindOfTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self sortArray];
//    [self cutNSString ];
//    [self reachabilityTest];
    [self initViews];
    
    // Do any additional setup after loading the view.
}

-(void)initViews
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
    table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    titleArray = [NSMutableArray arrayWithObjects:@"委托代理",@"其他", nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  titleArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = titleArray [indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self goToProtocal];
            break;
        case 1:
            NSLog(@"其他");
            break;
        default:
            break;
    }
}
-(void)goToProtocal
{
    ProtocalPractiseVC *protocal = [[ProtocalPractiseVC alloc]init];
    [self.navigationController pushViewController:protocal animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sortArray
{
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"2", @"3", @"1", @"4", nil];
    
    // 返回一个排好序的数组，原来数组的元素顺序不会改变
    // 指定元素的比较方法：compare:
    NSArray *array2 = [array sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"array2:%@", array2);
}

-(void)cutNSString
{
    NSString *animals = @"dog#cat#pig";
    //将#分隔的字符串转换成数组
    NSArray *array = [animals componentsSeparatedByString:@"#"];
    NSLog(@"animals:%@",array);
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
