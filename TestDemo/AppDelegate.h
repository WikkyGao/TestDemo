//
//  AppDelegate.h
//  TestDemo
//
//  Created by Wikky on 15/11/27.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ReachableSingleton.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) ReachableSingleton *reachable;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

