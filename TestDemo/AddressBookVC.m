//
//  AddressBookVC.m
//  DmoForTest
//
//  Created by Wikky on 15/11/18.
//  Copyright © 2015年 Wikky. All rights reserved.
//
#import "AddressBookVC.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
//#import "Model.h"
#import "pinyin.h"
#import "THContact.h"
#import "THContactPickerTableViewCell.h"
#import "AFNetworking.h"
#define kKeyboardHeight 0.0
#define kKeyboardHeightActive 216.0

@interface AddressBookVC ()
<UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableArray *dataSource;
    NSMutableArray *userSource;
    NSMutableArray *numarr1;
    NSMutableDictionary *dic1;
    THContact *ABModel;
    NSString *allPhone;
    int n ;
    UIView *v1;
    NSMutableArray *keys;
    UIBarButtonItem *finishBarButton;
}
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchTF ;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSArray *filteredContacts;
@property (nonatomic, strong) NSArray *contacts;


@end

@implementation AddressBookVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedContacts = [NSMutableArray array];

    [self address];
    [self initData];
    [self initTHContractPickerView];
    [self initViews];
    n = 0;
    if (self.babyid==nil) {
        self.babyid = @"F326381B-9829-4A77-AF06-35F76A31F5B1";
    }
    self.view.backgroundColor = [UIColor yellowColor];
}



#pragma mark THContactViewDeleGate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""] && self.selectedContacts.count < 1)
    {
        finishBarButton.enabled = false;

    }
    else
    {
        finishBarButton.enabled = YES;

    }
//    [self.tableView reloadData];
}
-(void)contactPickerDidRemoveContact:(id)contact
{
    
    [self.selectedContacts removeObject:contact];
    //刷新列表
    [self.tableView reloadData];
    n--;
    //重新选取还没删除的cell
    for (int i = 0; i < userSource.count; i++)
    {
        NSDictionary *dict = [userSource objectAtIndex:i];
        NSArray *arr = [[dict allValues]lastObject];
        for (int j = 0; j < arr.count; j++) {
            THContact *mt = [arr objectAtIndex:j];
            if ([self.selectedContacts containsObject:mt]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:YES scrollPosition:UITableViewScrollPositionNone ];
            }
        }
    }
    if (self.selectedContacts.count < 1) {
        finishBarButton.enabled = NO;
        
    }
}

-(void)contactPickerDidResize:(THContactPickerView *)contactPickerView
{
    [self adjustTableViewFrame:YES];
}

- (void)adjustTableViewFrame:(BOOL)animated {
    CGRect frame = self.tableView.frame;
    // This places the table view right under the text field
    frame.origin.y = self.contactPickerView.frame.size.height;
    // Calculate the remaining distance
    frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height -kKeyboardHeight - 45;
    
    if(animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        self.tableView.frame = frame;
        
        [UIView commitAnimations];
    }
    else
    {
        self.tableView.frame = frame;
    }
}
-(void)initTHContractPickerView
{
    self.contactPickerView  = [[THContactPickerView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 45)];
    self.contactPickerView.delegate = self;
    self.contactPickerView.backgroundColor = [UIColor lightGrayColor];
    //气泡颜色设置
    THBubbleColor *bbcolor = [[THBubbleColor alloc]initWithGradientTop:[UIColor colorWithRed:37/255.0 green:197/255.0 blue:223/255.0 alpha:1] gradientBottom:[UIColor colorWithRed:37/255.0 green:197/255.0 blue:223/255.0 alpha:1] border:[UIColor clearColor]];
    THBubbleColor *bbcolor1 = [[THBubbleColor alloc]initWithGradientTop:[UIColor colorWithRed:37/255.0 green:197/255.0 blue:223/255.0 alpha:0.5] gradientBottom:[UIColor colorWithRed:37/255.0 green:197/255.0 blue:223/255.0 alpha:0.5] border:[UIColor clearColor]];
    [self.contactPickerView setBubbleColor:bbcolor selectedColor:bbcolor1];
    [self.contactPickerView setPlaceholderString:@"输入要添加的联系人"];
    [self.view addSubview:self.contactPickerView];
    self.contactPickerView.textView.editable = NO;
}
-(void)initViews
{
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height -137 - kKeyboardHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    [self.tableView setEditing:YES animated:NO];
    self.tableView.dataSource = self;
    self.tableView.bounces = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];

    //======>>>
    v1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    v1.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:v1];
    finishBarButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    finishBarButton.enabled = NO;
    self.navigationItem.rightBarButtonItem  = finishBarButton;
    UIButton *btnTest = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTest.frame = CGRectMake(self.view.frame.size.width - 60, 0,80,50);
    btnTest.backgroundColor = [UIColor lightGrayColor];
    [btnTest addTarget:self action:@selector(addCustomerPhone) forControlEvents:UIControlEventTouchUpInside];
    [v1 addSubview:btnTest];
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 3, self.view.frame.size.width - 80, 44)];
    self.searchTF.backgroundColor = [UIColor whiteColor];
    [v1 addSubview:self.searchTF];
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardRemove:) name:UIKeyboardWillHideNotification object:nil];
    
    
}
//键盘消失
-(void)keyboardRemove:(NSNotification *)notii
{
    [UIView animateWithDuration:0.3 animations:^{
        v1.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    }];
}
-(void)keyboardShow:(NSNotification *)notii
{
    //获取键盘的高度
    NSDictionary *dic = notii.userInfo;
    //获取坐标
    CGRect rc =  [[dic objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //键盘高度
    CGFloat f = rc.size.height;
    //调整输入框的位置
    v1.frame = CGRectMake(0, self.view.frame.size.height - 50 - f, self.view.frame.size.width, 50);
    
}
-(void)addCustomerPhone
{
    if ([self.searchTF.text isEqualToString:@""])
    {
        return;
    }
    else
    {
        n++;
        THContact *addM = [[THContact alloc]init];
        addM.phone =   self.searchTF.text;
        [self.selectedContacts addObject:addM];
        [self.contactPickerView addContact:addM withName:self.searchTF.text];
        finishBarButton.enabled = YES;
        
        //        [self.contactPickerView addContact:addM withName:[NSString stringWithFormat:@"新增用户%d",n]];
    }
    self.searchTF.text = @"";
    [self.searchTF resignFirstResponder];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topOffset = 200;
    if ([self respondsToSelector:@selector(topLayoutGuide)]){
        topOffset = self.topLayoutGuide.length;
    }
    CGRect frame = self.contactPickerView.frame;
    frame.origin.y = topOffset;
    self.contactPickerView.frame = frame;
    [self adjustTableViewFrame:NO];
}
#pragma mark - 获取通讯录里联系人姓名和手机号
- (void)address
{
    dataSource = [[NSMutableArray alloc] init];
    
    //    NSMutableArray *contactsdata= [[NSMutableArray alloc] init];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    //判断是否在ios6.0版本以上
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0){
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        CFErrorRef* error=nil;
        addressBooks = ABAddressBookCreateWithOptions(NULL, error);
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        ABModel = [[THContact alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        ABModel.name = nameString;        // Set Contact properties
        ABModel.firstName = firstName;
        ABModel.lastName = lastName;
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        ABModel.phone = (__bridge NSString*)value;
                        break;
                    }
                        //                    case 1: {// Email
                        //                        addressBook.email = (__bridge NSString*)value;
                        //                        break;
                        //                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(person);
        ABModel.image = [UIImage imageWithData:imgData];
        if (!ABModel.image) {
            ABModel.image = [UIImage imageNamed:@"icon-avatar-60x60"];
        }

        //将个人信息添加到数组中，循环完成后addressBook中包含所有联系人的信息
        [dataSource addObject:ABModel];
        self.contacts = [NSArray arrayWithArray:dataSource];
        self.selectedContacts = [NSMutableArray array];
        self.filteredContacts = self.contacts;
//        if (abName) CFRelease(abName);
//        if (abLastName) CFRelease(abLastName);
//        if (abFullName) CFRelease(abFullName);
        [self.tableView reloadData];
    }
}
#pragma mark - 索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //便立构造器
    for (NSDictionary *dic in userSource)
    {
        //将取出来的数据封装成NSNumber类型
        NSNumber *num = [[dic allKeys] lastObject];
        //给a开空间，并且强转成char类型
        char *a = (char *)malloc(2);
        //将num里面的数据取出放进a里面
        sprintf(a, "%c", [num charValue]);
        //把c的字符串转换成oc字符串类型
        NSString *str = [[NSString alloc]initWithUTF8String:a];
        [array addObject:str];
    }
    return array;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contactPickerView.textView resignFirstResponder];
    [self.searchTF resignFirstResponder];

}
#pragma mark - 设置section的行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return userSource.count;
}
#pragma mark - 设置section的头部高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
#pragma mark - 设置section显示的内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [self.filteredContacts objectAtIndex:section];
    NSNumber *num = [[dic allKeys] lastObject];
    char *a = (char *)malloc(2);
    sprintf(a, "%c", [num charValue]);
    NSString *str = [[NSString alloc] initWithUTF8String:a];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    return btn;
}
#pragma mark - 设置每个section里的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [userSource objectAtIndex:section];
    NSArray *array = [[dic allValues] firstObject];
    return array.count;
}
#pragma mark - 显示每行内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSDictionary *dic = [userSource objectAtIndex:indexPath.section];
    NSMutableArray *arr = [[dic allValues] lastObject];
    THContact *mt = [arr objectAtIndex:indexPath.row];
    cell.textLabel.text = mt.name;
    cell.imageView.image = mt.image;
    cell.detailTextLabel.text = mt.phone;
    return cell;
}

-( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert ;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchTF resignFirstResponder];
    [self.contactPickerView resignKeyboard];
    finishBarButton.enabled = YES;
    NSDictionary *sectionDict = [userSource objectAtIndex:indexPath.section];
    NSArray *arr = [[sectionDict allValues] lastObject];
    THContact *user = [arr objectAtIndex:indexPath.row];
        // Set checkbox to "unselected"
    [self.selectedContacts addObject:user];
    [self.contactPickerView addContact:user withName:user.name];

}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.contactPickerView resignKeyboard];
    NSDictionary *sectionDict = [userSource objectAtIndex:indexPath.section];
    NSArray *arr = [[sectionDict allValues] lastObject];
    THContact *user = [arr objectAtIndex:indexPath.row];
    [self.selectedContacts removeObject:user];
    [self.contactPickerView removeContact:user];
    if (self.selectedContacts.count < 1) {
        finishBarButton.enabled = NO;
    }

}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)initData
{
    userSource = [[NSMutableArray alloc] init];
    for (char i = 'A'; i<='Z'; i++)
    {
        NSMutableArray *numarr = [[NSMutableArray alloc] init];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (int j=0; j<dataSource.count; j++)
        {
            THContact *model = [dataSource objectAtIndex:j];
            //获取姓名首位
            NSString *string = [model .name substringWithRange:NSMakeRange(0, 1)];
            //将姓名首位转换成NSData类型
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //data的长度大于等于3说明姓名首位是汉字
            if (data.length >=3)
            {
                //将汉字首字母拿出
                char a = pinyinFirstLetter([model.name characterAtIndex:0]);
                //将小写字母转成大写字母
                char b = a-32;
                if (b == i)
                {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:model.name];
                    if (model.phone != nil)
                    {
                        [array addObject:model.phone];
                    }
                    
                    [numarr addObject:model];
//                    [numarr addObject:array];
                    [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                }
                
            }
            else
            {
                //data的长度等于1说明姓名首位是字母或者数字
                if (data.length == 1)
                {
                    //判断姓名首位是否位小写字母
                    NSString * regex = @"^[a-z]$";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    BOOL isMatch = [pred evaluateWithObject:string];
                    if (isMatch == YES)
                    {
                        //NSLog(@"这是小写字母");
                        
                        //把大写字母转换成小写字母
                        char j = i+32;
                        //数据封装成NSNumber类型
                        NSNumber *num = [NSNumber numberWithChar:j];
                        //给a开空间，并且强转成char类型
                        char *a = (char *)malloc(2);
                        //将num里面的数据取出放进a里面
                        sprintf(a, "%c", [num charValue]);
                        //把c的字符串转换成oc字符串类型
                        NSString *str = [[NSString alloc]initWithUTF8String:a];
                        if ([string isEqualToString:str])
                        {
                            NSMutableArray *array = [[NSMutableArray alloc] init];

                            [array addObject:model.name];
                            if (model.phone != nil)
                            {
                                [array addObject:model.phone];
                            }
                            
//                            [numarr addObject:array];
                            [numarr addObject:model];
                            [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                        }
                        
                    }
                    else
                    {
                        //判断姓名首位是否为大写字母
                        NSString * regexA = @"^[A-Z]$";
                        NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
                        BOOL isMatchA = [predA evaluateWithObject:string];
                        if (isMatchA == YES)
                        {
                            //NSLog(@"这是大写字母");
                            //
                            NSNumber *num = [NSNumber numberWithChar:i];
                            //给a开空间，并且强转成char类型
                            char *a = (char *)malloc(2);
                            //将num里面的数据取出放进a里面
                            sprintf(a, "%c", [num charValue]);
                            //把c的字符串转换成oc字符串类型
                            NSString *str = [[NSString alloc]initWithUTF8String:a];
                            if ([string isEqualToString:str])
                            {
                                
                                NSMutableArray *array = [[NSMutableArray alloc] init];
                                [array addObject:model.name];
                                if (model.phone != nil)
                                {
                                    [array addObject:model.phone];
                                }

//                                [numarr addObject:array];
                                [numarr addObject:model];
                                [dic setObject:numarr forKey:[NSNumber numberWithChar:i]];
                            }
                        }
                    }
                }
            }
        }
        if (dic.count != 0)
        {
            [userSource addObject:dic];
        }
    }
    char a = '#';
    int cont = 0;
    for (int j=0; j<dataSource.count; j++)
    {
        THContact *model = [dataSource objectAtIndex:j];
        //获取姓名的首位
        NSString *string = [model.name substringWithRange:NSMakeRange(0, 1)];
        //将姓名首位转化成NSData类型
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        //判断data的长度是否小于3
        if (data.length < 3)
        {
            if (cont == 0)
            {
                dic1 = [[NSMutableDictionary alloc] init];
                numarr1 = [[NSMutableArray alloc] init];
                cont++;
            }
            if (data.length == 1)
            {
                //判断首位是否为数字
                NSString * regexs = @"^[0-9]$";
                NSPredicate *preds = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexs];
                BOOL isMatch = [preds evaluateWithObject:string];
                if (isMatch == YES)
                {
                    //如果姓名为数字
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:model.name];
                    if (model.phone != nil)
                    {
                        [array addObject:model.phone];
                    }

//                    [numarr1 addObject:array];
                    [numarr1 addObject:model];
                    [dic1 setObject:numarr1 forKey:[NSNumber numberWithChar:a]];
                }
            }
            else
            {
                //如果姓名为空
                NSMutableArray *array = [[NSMutableArray alloc] init];
                model.name = @"无";
//                model.firstName = @"无";
//                model.lastName = @"";
                [array addObject:model.name];
                if (model.phone != nil)
                {
                    [keys addObject:model];
                    [array addObject:model.phone];
//                    [numarr1 addObject:array];
                    [numarr1 addObject:model];
                    [dic1 setObject:numarr1 forKey:[NSNumber numberWithChar:a]];
                }
            }
        }
    }
    if (dic1.count != 0)
    {
        [userSource addObject:dic1];
    }
    self.filteredContacts = userSource;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击完成时执行下面方法
- (void)done
{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done!"
    //                                                        message:@"Now do whatevet you want!"
    //                                                       delegate:nil
    //                                              cancelButtonTitle:@"Ok"
    //                                              otherButtonTitles:nil];
    //    [alertView show];
//    if (![self.contactPickerView.textView.text isEqualToString:@""]) {
//        THContact *addM = [[THContact alloc]init];
//        addM.phone = self.contactPickerView.textView.text;
//        [self.selectedContacts addObject:addM];
//        [self.contactPickerView addContact:addM withName:@"新增监护人"];
//    }
    allPhone = @"";
    NSMutableArray *phoneArr = [NSMutableArray array];
    for (int i = 0; i < self.selectedContacts.count; i++)
    {
        THContact *tem = [self.selectedContacts objectAtIndex:i];
        if (tem.phone) {
            [phoneArr addObject:tem.phone];
        }
    }
    for (NSString *str  in phoneArr) {
        NSLog(@"%@",str);
    }

//    [self contactPickerTextViewDidChange:self.contactPickerView.textView.text];
    //提取电话号码,合并为以逗号分隔的字符串
//    allPhone =[NSString stringWithFormat:@"%@,",self.contactPickerView.textView.text];
    for (NSString *tt in phoneArr) {
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:NULL];
        NSString *result = [regular stringByReplacingMatchesInString:tt options:0 range:NSMakeRange(0, [tt length]) withTemplate:@""];
        if ([result hasPrefix:@"86"]) {
            result =  [tt substringFromIndex:3];
        }
        result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
        allPhone = [allPhone stringByAppendingString:[NSString stringWithFormat:@"%@,",result]];
    }
    
    NSLog(@"allPhone ===>%@", allPhone);
        [self urlRequestWithUserID:@"4"
                             phone:allPhone
                            babyID:self.babyid];
    
}
-(void)urlRequestWithUserID:(NSString *)userid phone:(NSString*)phone babyID:(NSString *)babyid
{
    NSString *urlStr =@"http://119.134.250.31/index/active_share";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //很重要，去掉就容易遇到错误，暂时还未了解更加详细的原因
    [manager POST:urlStr parameters:
     @{
       @"userid":userid,
       @"phone":phone,
       @"babyid":babyid
       }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *dict =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSString *str = [dict objectForKey:@"status"];
              NSLog(@"JSON: %@", str);
              
              [self dismissViewControllerAnimated:YES completion:^{
                  
              }];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"error:%@",error.localizedDescription);
          }];
}
@end
