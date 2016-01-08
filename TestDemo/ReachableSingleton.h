//
//  ReachableSingleton.h
//  Reachability
//
//  Created by caigee on 14-6-26.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define REACHABLE_CHANGED_NOTIFICATION @"REACHABLE_CHANGED_NOTIFICATION"


@interface ReachableSingleton : NSObject

@property (nonatomic,retain)Reachability *currentReachablity;
@property (nonatomic)NetworkStatus currentStatus;

+ (ReachableSingleton *) sharedInstance;
-(BOOL)isConnected;
-(BOOL)isConnectedByWifi;
-(BOOL)isConnectedByWwan;
@end
