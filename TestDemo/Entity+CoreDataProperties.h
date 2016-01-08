//
//  Entity+CoreDataProperties.h
//  TestDemo
//
//  Created by Wikky on 15/12/15.
//  Copyright © 2015年 Wikky. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *babyid;
@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
