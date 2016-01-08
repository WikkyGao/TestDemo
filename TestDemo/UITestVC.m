//
//  UITestVC.m
//  DmoForTest
//
//  Created by Wikky on 15/11/27.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "UITestVC.h"
#import "GuardianCVCell.h"
#import "GuardianCVCell.h"
#import "ShareListModel.h"
#import "AFNetworking.h"
#import "AddressBookVC.h"
#import "MBProgressHUD.h"
#import "BlueHeader.h"
@interface UITestVC ()<
//ModelCellDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
MBProgressHUDDelegate>
{
    NSMutableArray *titleData;
    NSMutableArray *useridData;
    NSMutableArray *arrayData;
    NSMutableArray *arraySelected;
    BOOL deleteMode;
    NSMutableDictionary *resultDict;
    UIBarButtonItem *rightItem;
    MBProgressHUD *hud;

}
@property(nonatomic,strong)    UICollectionView *cv;
@property(nonatomic,strong)    NSString *babyid;
@end

@implementation UITestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self initViews];
    self.babyid = @"8397AEF8-71C2-4151-8754-3D6AFBF7E8D7";
    hud.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"同步中...";
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
        [self babyListURLRequest];
//        sleep(2);

    } completionBlock:^{
        [hud removeFromSuperview];
        [_cv reloadData];
    }];
    
}
-(void)babyListURLRequest
{
    
    arraySelected = [NSMutableArray array];
    arrayData = [NSMutableArray array];//cell数据源
    titleData = [NSMutableArray array];
    useridData  = [NSMutableArray array];
    NSString *strHost = Host;
    NSString *strPort = @"/have_baby";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",strHost,strPort];
    resultDict = [NSMutableDictionary dictionary];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //很重要，去掉就容易遇到错误，暂时还未了解更加详细的原因
    [manager POST:urlStr parameters:
     @{
       @"babyid":self.babyid,
       }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSMutableDictionary *dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              //            NSString *str = [dict objectForKey:@"status"];
              resultDict = dict;
              NSArray *arrayD = [resultDict valueForKey:@"user_list"];
              for (int i = 0; i < arrayD.count; i++) {
                  [titleData addObject:[[arrayD objectAtIndex:i]valueForKey:@"name"]];
              }              for (int i = 0; i < arrayD.count; i++) {
                  [useridData addObject:[[arrayD objectAtIndex:i]valueForKey:@"userid"]];
              }
              
              for (int i = 0; i < titleData.count; i++) {
                  ShareListModel *mt = [[ShareListModel alloc]init];
                  mt.text = [titleData objectAtIndex:i];
                  mt.tag = i;
                  mt.userid = [useridData objectAtIndex:i];
                  mt.isSelected = NO;
                  mt.img = [UIImage imageNamed:@"icon8"];
                  
                  [arrayData addObject: mt];
              }
              hud.mode = MBProgressHUDModeText;
              hud.labelText = @"OK";
              NSString *str = [dict objectForKey:@"user_list"];
              NSLog(@"JSON: %@", str);
//              [_cv reloadData];
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error:%@",error.localizedDescription);
              hud.mode = MBProgressHUDModeText;
              hud.labelText = @"网络出错了啦";
              [hud hide:YES afterDelay:2.0f];
          }];
    
}
-(void)initViews
{
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:37/255.0 green:197/255.0 blue:223/255.0 alpha:1];
    
    
    deleteMode = NO;
    self.title = @"档案共享中心";
    rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    rightItem.tintColor  = [UIColor whiteColor];
    rightItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = rightItem;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:[common localzedStringkey:@"cancel"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
//    leftItem.tintColor  = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    //=======
    //创建一个布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置最小行间距
    layout.minimumLineSpacing = 20;
    //设置最小列间距
    layout.minimumInteritemSpacing = 10;
    //设置垂直滚动
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置外面上左下右的间距
    layout.sectionInset = UIEdgeInsetsMake(20, 25, 20, 25);
    //设置每一个item(小方块)大小 通常小方块的大小我们通过代理方法来设置
    _cv = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) collectionViewLayout:layout];
    
    //注册cell UICollectionView 的 cell必须注册
    [_cv registerClass:[GuardianCVCell class] forCellWithReuseIdentifier:@"cell"];
    //注册header
    [_cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //设置代理
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_cv];
    
    //    [self.view addSubview:btnTest];
    
}


#pragma  mark UICollectionViewDelegate
//每个section显示的cell个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayData.count + 2 ;
    return arrayData.count ;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GuardianCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < arrayData.count )
    {
        ShareListModel *st = [arrayData objectAtIndex:indexPath.row];
        if (!deleteMode )
        {
            st.text = [titleData objectAtIndex:indexPath.row];
            cell.img.image = st.img;
            cell.userName.text = st.text;
            cell.delectView.text = st.delectText;
            cell.delectView.hidden = YES;
            
        }
        else
        {
            cell.img.image = st.img;
            cell.userName.text = st.text;
            cell.delectView.text = st.delectText;
            cell.delectView.hidden = NO;
        }
    }
    
    else  if (indexPath.row == arrayData.count)
    {
        cell.userName.text = @"添加";
        cell.img.backgroundColor =[UIColor clearColor];
        cell.img.image = [UIImage imageNamed:@"icon3"];
        cell.delectView.hidden = YES;
        
    }
    if(indexPath.row > arrayData.count)
    {
        cell.userName.text = @"删除";
        cell.img.backgroundColor = [UIColor clearColor];
        cell.img.image = [UIImage imageNamed:@"icon4"];
        cell.delectView.hidden = YES;
        
    }
    return cell;
}
//分段 (页眉)
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//控制每个小方块大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((mainWidth - 40 - 3*20)/4, ((mainWidth - 40 - 3*20)/4) + 30);
}
//分区高度,页眉高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return  CGSizeMake(self.view.frame.size.width, 0);
}
//分区 页眉的样子
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是页眉
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor orangeColor];
        return headerView;
    }
    return nil;
    
}
//点击的第几分区的第几个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < arrayData.count && arrayData)
    {
        ShareListModel *mt = [arrayData objectAtIndex:indexPath.row];
        if (deleteMode)
        {
            if (!mt.isSelected)
            {
                mt.delectText = @"-";
                //                mt.img = nil;
                mt.isSelected = YES;
                [arrayData replaceObjectAtIndex:indexPath.row withObject:mt];
                [arraySelected addObject:mt.userid];
                NSLog(@"%@<<<<",mt.userid);
                [_cv reloadData];
                
            }
            else
            {
                mt.delectText = @"";
                //                mt.background = [UIColor greenColor];
                //                mt.img = [UIImage imageNamed:@"icon8"];
                mt.text = [titleData objectAtIndex:indexPath.row];
                mt.isSelected = NO;
                [arrayData replaceObjectAtIndex:indexPath.row withObject:mt];
                if ([arraySelected containsObject:mt.userid]) {
                    [arraySelected removeObject:mt.userid];
                }
                [_cv reloadData];
            }
        }
    }
    else if (indexPath.row == arrayData.count)
    {
        
        AddressBookVC *addressBook = [[AddressBookVC alloc]init];
//        UINavigationController *navAddBook  =[[UINavigationController alloc]initWithRootViewController:addressBook];
        if (deleteMode)
        {
            deleteMode = NO;
            for (ShareListModel *m in arrayData) {
                m.delectText = @"";
                m.isSelected = NO;
                m.img = [UIImage imageNamed:@"icon8"];
            }
            [arraySelected removeAllObjects];
            //            NSLog(@"退出删除模式");
            [_cv reloadData];
            
        }
//        [navAddBook.navigationBar setTitleTextAttributes:
//         @{NSFontAttributeName:[UIFont systemFontOfSize:19],
//           NSForegroundColorAttributeName:[UIColor whiteColor]}];
        addressBook.babyid = self.babyid;
        [self.navigationController pushViewController:addressBook animated:YES];
    }
    else  if(indexPath.row > arrayData.count)
    {
        if (deleteMode)
        {
            deleteMode = NO;
            for (ShareListModel *m in arrayData) {
                m.delectText = @"";
                m.isSelected = NO;
                m.img = [UIImage imageNamed:@"icon8"];
            }
            
            [arraySelected removeAllObjects];
            //            NSLog(@"退出删除模式");
            [_cv reloadData];
            
        }
        else
        {
            deleteMode = YES;
            
            //            NSLog(@"删除模式");
            [_cv reloadData];
            
        }
    }
    if (arraySelected.count > 0)
    {
        rightItem.enabled = YES;
    }
    else
    {
        rightItem.enabled = NO;
    }
}
-(void)finishAction
{
    if(arraySelected)
    {
        self.navigationController.navigationItem.rightBarButtonItem.enabled = YES;
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"删除选择的账号么?"] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertV show];
    }
}
#pragma mark- alert delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *usersString = [arraySelected componentsJoinedByString:@","];
    NSLog(@"%@",usersString);
    if (buttonIndex == 1) {
        
        [self deleteAccountRequestWithUsersString:usersString];
        hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"刷新中...";
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
            [self babyListURLRequest];
            sleep(2);
            
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
    }
}

-(void)deleteAccountRequestWithUsersString:(NSString *)usersString
{
    NSString *strHost = Host;
    NSString *strPort = @"/active_unshare";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",strHost,strPort];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //很重要，去掉就容易遇到错误，暂时还未了解更加详细的原因
    [manager POST:urlStr parameters:
     @{
       @"userid":@"4",
       @"target_userid":usersString,
       @"babyid":self.babyid
       }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSString *str = [dict objectForKey:@"status"];
              NSLog(@"JSON: %@", str);
              //将要删除的数据源下标保存到at
              NSMutableArray *at =[NSMutableArray array];
              for (int i = 0; i < arrayData.count; i++)
              {
                  ShareListModel *modelTem = [arrayData objectAtIndex:i];
                  if([arraySelected containsObject:modelTem.userid])
                  {
                      [at addObject:[NSString stringWithFormat:@"%d",i]];
                  }
              }
              //删除选取的cell和对应数据源
              for (int i = 0; i < at.count; i++) {
                  [arrayData removeObjectAtIndex:[[at firstObject] intValue]];
                  [titleData removeObjectAtIndex:[[at firstObject] intValue]];
                  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[at firstObject] intValue] inSection:0];
                  [_cv deleteItemsAtIndexPaths:@[indexPath]];
              }
              //删除选中的数组
              [arraySelected removeAllObjects];
              rightItem.enabled = NO;
              deleteMode = NO;
              [_cv reloadData];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error:%@",error.localizedDescription);
          }
     ];
}
-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//-(void)refreshView
//{
//    NSLog(@"delegate");
//    [_cv reloadData];
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
