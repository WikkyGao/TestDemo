//
//  AddressBookVC.h
//  DmoForTest
//
//  Created by Wikky on 15/11/18.
//  Copyright © 2015年 Wikky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THContactPickerView.h"

@interface AddressBookVC : UIViewController<THContactPickerDelegate>

@property (nonatomic, strong) THContactPickerView *contactPickerView;
@property (nonatomic, strong) NSString *babyid;

@end
