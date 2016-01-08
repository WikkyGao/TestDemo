//
//  AppDelegate.m
//  TestDemo
//
//  Created by Wikky on 15/11/27.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Reachability.h"
//#import "MyTabbarVC.h"
//#import "MQTTKitTestVC.h"
//#import "UIStaffVC.h"
//#import "FontAwesomeKitTestVC.h"
//#import "AddressBookVC.h"
@interface AppDelegate ()
@property(nonatomic,strong)Reachability *reachHost;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ViewController *root = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
//    MQTTKitTestVC *mqtt = [[MQTTKitTestVC alloc]init];
//    UIStaffVC *uiTest = [[UIStaffVC alloc]init];
//    FontAwesomeKitTestVC *fak = [[FontAwesomeKitTestVC alloc]init];
//    AddressBookVC *address = [[AddressBookVC alloc]init];
//    
//
//    UINavigationController *navMqtt = [[UINavigationController alloc]initWithRootViewController:mqtt];
//    UINavigationController *navUiTest = [[UINavigationController alloc]initWithRootViewController:uiTest];
//    UINavigationController *navFak = [[UINavigationController alloc]initWithRootViewController:fak];
//    UINavigationController *navAddress = [[UINavigationController alloc]initWithRootViewController:address];
//    
//    
//    MyTabbarVC *tab = [[MyTabbarVC alloc]init];
//    tab.viewControllers = [NSArray arrayWithObjects:navMqtt,navUiTest,navFak,navAddress, nil];
//    self.window.rootViewController = tab;
    self.window.rootViewController = nav;
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor: [ UIColor lightGrayColor]];
    
    //一般在程序第一次启动时创建需要的数据库表
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    
    //    [de setObject:@"第一次启动" forKey:@"firstStart"];
    NSString *str = [de objectForKey:@"firstStart"];
    if ([str isEqualToString:@"第一次启动"]) {
        //不是第一次启动
                NSLog(@"不是第一次");
    }else{
        //是第一次启动
        [de setObject:@"第一次启动" forKey:@"firstStart"];
        NSString *clienID =[[NSUUID UUID]UUIDString];
        [de setObject:clienID forKey:@"ClientID"];

                NSLog(@"第一次运行");
    }
    [self reachabilityTest];
    return YES;
}


-(void)reachabilityTest
{
    _reachHost = [Reachability reachabilityWithHostName:@"119.134.250.31"];
    NSLog(@"---current state====%ld",(long)_reachHost.currentReachabilityStatus);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reachHost startNotifier]; //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: _reachHost];
    //.....

}
- (void)reachabilityChanged: (NSNotification*)note
{
    Reachability*curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

//处理连接改变后的情况

- (void)updateInterfaceWithReachability: (Reachability*)curReach
{
    //对连接改变做出响应的处理动作。
    
    NetworkStatus status=[curReach currentReachabilityStatus];
    
    if (status== NotReachable) { //没有连接到网络就弹出提实况
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"MyApp Name"
                                                       message:@"NotReachable"
                                                      delegate:nil
                                             cancelButtonTitle:@"YES" otherButtonTitles:nil];
        [alert show];
    }
    if (status== ReachableViaWiFi) { //没有连接到网络就弹出提实况
//        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"MyApp Name"
//                                                       message:@"连WiFi了"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"YES" otherButtonTitles:nil];
//        [alert show];
        NSLog(@"连wifi了");
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "-4.TestDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
