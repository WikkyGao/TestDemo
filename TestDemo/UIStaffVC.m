//
//  UIStaffVC.m
//  TestDemo
//
//  Created by Wikky on 15/12/15.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "UIStaffVC.h"
#import "UITestVC.h"
#import "WebTestVC.h"
#import "RadioBtnVC.h"
@interface UIStaffVC ()
{
    NSMutableArray *titleArray;
}
@end

@implementation UIStaffVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    titleArray = [NSMutableArray arrayWithObjects:@"CollectionView",@"RadioButton",@"WebView" ,nil];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    
    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self goToColletctionViewTest];
            break;
        case 1:
            [self radioButtonTest];
            break;
        case 2:
            [self webTest];
            break;
        default:
            break;
    }
}
-(void)webTest
{
    WebTestVC *web = [[WebTestVC alloc]init];
    [self.navigationController pushViewController:web animated:YES];
}
-(void)radioButtonTest
{
    RadioBtnVC *radiobtn = [[RadioBtnVC alloc]init];
    [self.navigationController pushViewController:radiobtn animated:YES ];
}
-(void)goToColletctionViewTest
{
    UITestVC *collectionViewTest = [[UITestVC alloc]init];
    [self.navigationController pushViewController:collectionViewTest animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
