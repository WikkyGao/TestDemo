//
//  ShareListModel.h
//  Thermometer
//
//  Created by Wikky on 15/11/30.
//  Copyright © 2015年 ouguoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShareListModel : NSObject
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSString  *delectText;
@property(nonatomic,strong)UIImage *img;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,assign)int tag;
@property(nonatomic,strong)NSString *userid;
@end
