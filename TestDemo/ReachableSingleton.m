//
//  ReachableSingleton.m
//  Reachability
//
//  Created by caigee on 14-6-26.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "ReachableSingleton.h"
#import "Reachability.h"
#define Host @"119.134.251.155"

static ReachableSingleton *_singleton = nil;

@implementation ReachableSingleton

+ (ReachableSingleton *) sharedInstance
{
    if (_singleton ==nil) {
        _singleton = [[ReachableSingleton alloc]init];
    }
    return _singleton;
}

-(BOOL)isConnected
{
    if (self.currentStatus!=NotReachable) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isConnectedByWifi
{
    if (self.currentStatus==ReachableViaWiFi) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)isConnectedByWwan
{
    if (self.currentStatus==ReachableViaWWAN) {
        return YES;
    }else{
        return NO;
    }
}

-(id)init
{
    self = [super init];
    
    if (self) {
        self.currentStatus = -1;
        [self initCurrentNetWork];
    }
    return self;
}
-(void)dealloc
{
    [self.currentReachablity stopNotifier];
    self.currentReachablity = nil;
    
}

// 第一次直接获取网络信息
-(void)initCurrentNetWork
{
    self.currentReachablity = [Reachability reachabilityWithHostName:Host];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [self.currentReachablity startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self refreshNetStatus:curReach];
    
}

-(void)refreshNetStatus:(Reachability *)currentRec
{
    NSParameterAssert([currentRec isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [currentRec currentReachabilityStatus];
    if (netStatus==NotReachable || netStatus == ReachableViaWiFi ||netStatus == ReachableViaWWAN)
    {
        if (self.currentStatus != netStatus) {
            //先赋值再发通知
            self.currentStatus = netStatus;
            [[NSNotificationCenter defaultCenter]postNotificationName:REACHABLE_CHANGED_NOTIFICATION object:nil];
        }
    }
}

@end
