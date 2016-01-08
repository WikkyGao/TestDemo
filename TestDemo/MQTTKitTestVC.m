//
//  MQTTKitTestVC.m
//  demo2
//
//  Created by Wikky on 15/10/27.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "MQTTKitTestVC.h"
#import "MQTTKit.h"
#import "AppDelegate.h"
#import "BlueHeader.h"
//#define Host @"119.134.251.155"

@interface MQTTKitTestVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITextField *input;
@property(nonatomic,strong)UITextField *input1;
@property(nonatomic,strong)MQTTClient *client;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *msgArray;
@property(nonatomic,strong)UITableView *tab;
@property(nonatomic,strong)NSString *str ;

@end

@implementation MQTTKitTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"MQTT测试";
    
    
    NSString *clientID = [[NSUserDefaults standardUserDefaults]valueForKey:@"ClientID"];
    self.client = [[MQTTClient alloc]initWithClientId:clientID];
    [self initViews];
    [self receiveMsg];
    
    
    
    //////======
    NSLog(@"%@",clientID);

    // [self cutNSString];
    // Do any additional setup after loading the view.
}


-(void)initViews
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:self action:@selector(popTO)];

    self.input = [[UITextField alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20 , 45)];
    self.input.backgroundColor = [UIColor lightTextColor];
    self.input.placeholder = @"输入发送消息";
    
    [self.view addSubview:self.input];
    
    self.input1 = [[UITextField alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 20 , 45)];
    self.input1.backgroundColor = [UIColor lightTextColor];
    self.input1.text = @"737D4676-64A3-4FF0-ACC1-944284DCB3A2";
    self.input1.placeholder = @"输入topic";
    
    [self.view addSubview:self.input1];
    self.view .backgroundColor = [UIColor whiteColor];
    UIButton  *btn1  = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"发送消息" forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 6;
    btn1.layer.masksToBounds = YES;
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget: self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setFrame:CGRectMake(50, 150, 200, 50)];
    [btn1 setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:btn1];

    _tab = [[UITableView alloc]initWithFrame:CGRectMake(50, 250, 200, 200)];
    _tab.delegate= self;
    _tab.dataSource = self;
    self.array = [@[@""]mutableCopy];
    self.msgArray = [NSMutableArray array];
    [self.view addSubview:_tab];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.input resignFirstResponder];
}
-(void)sendMsg
{
    [self.input resignFirstResponder];

    __weak typeof(self)weakSelf = self;

    [self.client connectToHost:MQTTHosts completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            //当客户端连接,发送一条MQTT消息
            [self.client publishString:self.input.text toTopic:self.input1.text withQos:AtMostOnce retain:NO completionHandler:^(int mid) {
                NSLog(@"message has been delivered");
                [weakSelf.array insertObject:self.input.text atIndex:0];
//                [weakSelf.msgArray insertObject:@{@"message":self.input.text,@"position":@"right"} atIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tab reloadData];
                    [weakSelf.tab scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                });
            }];
            [self.client subscribe:self.input1.text
             withCompletionHandler:nil];
        }
    }];
}

-(void)receiveMsg
{
    __weak typeof(self)weakSelf = self;

    // connect the MQTT client
    
    [self.client connectToHost:MQTTHosts
             completionHandler:^(MQTTConnectionReturnCode code) {
                 if (code == ConnectionAccepted) {
                     // when the client is connected, subscribe to the topic to receive message.
                     [self.client subscribe:self.input1.text withCompletionHandler:nil];
                     [self.client subscribe:@"advertisement" withCompletionHandler:nil];
                 }
             }];
    // define the handler that will be called when MQTT messages are received by the client
    [self.client setMessageHandler:^(MQTTMessage *message) {
        NSError *err;
        NSData *data = [[message payloadString] dataUsingEncoding:NSUTF8StringEncoding] ;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
        if ([dict valueForKey:@"temperature"]) {
            weakSelf.str = [dict valueForKey:@"temperature"];
            NSLog(@"received message%@===<<<",weakSelf.str);
            [weakSelf.array insertObject:[NSString stringWithFormat:@"Tem - %@",weakSelf.str] atIndex:0];
        }
        NSString *ad_text = [message payloadString];
        [weakSelf.array insertObject:[NSString stringWithFormat:@"AD - %@",ad_text] atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tab reloadData];
            [weakSelf.tab scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }];
}
-(void)disconnect
{
    [self.client disconnectWithCompletionHandler:^(NSUInteger code) {
        NSLog(@"MQTT disconnect");
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
//    NSLog(@"%@====>",[[self.msgArray objectAtIndex:indexPath.row]valueForKey:@"position"]);
    cell.textLabel.text = self.array[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.input.text = [self.array objectAtIndex:indexPath.row];
}
-(void)popTO
{
    [self disconnect];
    [self.navigationController popToRootViewControllerAnimated:YES];
}//-(void)cutNSString
//{
//    NSString *animals = @"dog#cat#pig";
//    //将#分隔的字符串转换成数组
//    NSArray *array = [animals componentsSeparatedByString:@"#"];
//    NSLog(@"animals:%@",array);
//}
//-(void)sortArray
//{
//    //    _temWarnLevelArray = [NSMutableArray array];
//    //    for (int i = 0; i < 12 ; i++) {
//    //        NSString *temt = @"";
//    //        switch (i) {
//    //            case 0:
//    //                temt = @"37.2";
//    //                break;
//    //            case 1:
//    //                temt = @"38.0";
//    //                break;
//    //            case 2:
//    //                temt = @"39.0";
//    //                break;
//    //            case 3:
//    //                temt = @"39.5";
//    //                break;
//    //            case 4:
//    //                temt = @"40.0";
//    //                break;
//    //            case 5:
//    //                temt = @"40.3";
//    //                break;
//    //            case 6:
//    //                temt = @"40.6";
//    //                break;
//    //            case 7:
//    //                temt = @"40.9";
//    //                break;
//    //            case 8:
//    //                temt = @"41.2";
//    //                break;
//    //            case 9:
//    //                temt = @"41.5";
//    //                break;
//    //            case 10:
//    //                temt = @"41.8";
//    //                break;
//    //            case 11:
//    //                temt = @"42.8";
//    //                break;
//    //            default:
//    //                break;
//    //        }
//    //        [_temWarnLevelArray addObject:temt];
//    //    }
//    //    NSString *ttt = @"38.4";
//    //
//    //    [_temWarnLevelArray addObject:ttt];
//    //    NSMutableArray *sortArray =(NSMutableArray*)[_temWarnLevelArray sortedArrayUsingSelector:@selector(components:)];
//    //
//    //    NSLog(@"%@",sortArray);
////    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"2", @"3", @"1", @"4", nil];
////    
////    // 返回一个排好序的数组，原来数组的元素顺序不会改变
////    // 指定元素的比较方法：compare:
////    NSArray *array2 = [array sortedArrayUsingSelector:@selector(compare:)];
////    NSLog(@"array2:%@", array2);
////    
//}

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
