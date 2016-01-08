//
//  GuardianCVCell.m
//  Thermometer
//
//  Created by Wikky on 15/11/25.
//  Copyright © 2015年 ouguoquan. All rights reserved.
//

#import "GuardianCVCell.h"

@implementation GuardianCVCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.img.backgroundColor = [UIColor lightGrayColor];
        self.img.layer.cornerRadius = frame.size.width/2;
        self.img.layer.masksToBounds = YES;
        [self.contentView addSubview:self.img];
        
        self.userName = [[UILabel alloc]initWithFrame:CGRectMake(0,frame.size.height -30 , frame.size.width, 30)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.textAlignment = NSTextAlignmentCenter;
        self.userName.font = [UIFont systemFontOfSize:10];
        self.userName.text =@"么么哒";
        [self.contentView addSubview:self.userName];


        self.delectView = [[UILabel alloc]initWithFrame:CGRectMake(-5, 0, frame.size.width/3, frame.size.width/3)];
        self.delectView.backgroundColor = [UIColor redColor];
        self.delectView.text =@"-";
        self.delectView.textAlignment = NSTextAlignmentCenter;
        self.delectView.textColor = [UIColor whiteColor];
        self.delectView.font = [UIFont systemFontOfSize:20];

        self.delectView.layer.cornerRadius = self.delectView.frame.size.width/2;
        self.delectView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.delectView];
    }
    return self;
}
@end
